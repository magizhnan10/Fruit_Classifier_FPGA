module rf_top(
    input [31:0] data_in,
    output reg [1:0] final_class,

    // -------- DEBUG OUTPUTS --------
    output [23:0] debug_w_scaled,
    output [23:0] debug_h_scaled
);

// -------- UNPACK --------
wire [7:0] color;
wire [7:0] height;
wire [15:0] width;

assign color  = data_in[7:0];
assign height = data_in[15:8];
assign width  = data_in[31:16];

// -------- SAFE RATIO WIRES --------
wire [23:0] w_scaled;
wire [23:0] h_scaled;

assign w_scaled = width * 10;
assign h_scaled = height * 7;

// connect debug outputs
assign debug_w_scaled = w_scaled;
assign debug_h_scaled = h_scaled;

// -------- TREE OUTPUTS --------
reg [1:0] c0, c1, c2, c3;

// ================= TREE 0 =================
always @(*) begin
    if (height <= 8'd72)
        c0 = 2'd2;
    else begin
        if (color <= 8'd2) begin
            if (width <= 16'd55)
                c0 = 2'd1;
            else
                c0 = 2'd0;
        end else
            c0 = 2'd3;
    end
end

// ================= TREE 1 (RATIO) =================
always @(*) begin
    if (w_scaled <= h_scaled) begin
        if (width <= 16'd55)
            c1 = 2'd1;
        else
            c1 = 2'd3;
    end else begin
        if (color <= 8'd1)
            c1 = 2'd0;
        else
            c1 = 2'd2;
    end
end

// ================= TREE 2 =================
always @(*) begin
    if (width <= 16'd52)
        c2 = 2'd1;
    else begin
        if (height <= 8'd95) begin
            if (height <= 8'd65)
                c2 = 2'd2;
            else
                c2 = 2'd0;
        end else
            c2 = 2'd3;
    end
end

// ================= TREE 3 =================
always @(*) begin
    if (width <= 16'd52)
        c3 = 2'd1;
    else begin
        if (color <= 8'd1)
            c3 = 2'd0;
        else begin
            if (height <= 8'd92)
                c3 = 2'd2;
            else
                c3 = 2'd3;
        end
    end
end

// ================= VOTING =================
reg [2:0] count0, count1, count2, count3;

always @(*) begin
    count0 = (c0==2'd0) + (c1==2'd0) + (c2==2'd0) + (c3==2'd0);
    count1 = (c0==2'd1) + (c1==2'd1) + (c2==2'd1) + (c3==2'd1);
    count2 = (c0==2'd2) + (c1==2'd2) + (c2==2'd2) + (c3==2'd2);
    count3 = (c0==2'd3) + (c1==2'd3) + (c2==2'd3) + (c3==2'd3);

    if (count0 >= count1 && count0 >= count2 && count0 >= count3)
        final_class = 2'd0;
    else if (count1 >= count2 && count1 >= count3)
        final_class = 2'd1;
    else if (count2 >= count3)
        final_class = 2'd2;
    else
        final_class = 2'd3;
end

endmodule