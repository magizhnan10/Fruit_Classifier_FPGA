# Fruit Classifier on FPGA

A Random Forest fruit classifier (Apple, Banana, Orange, Mango)
trained in Python and deployed on FPGA using Verilog.

## Files
- `rf_top.v` — Verilog module implementing the 4-tree RF with majority voting
- `train_model.ipynb` — Jupyter notebook to train the sklearn model and export trees
- `fpga_predict.py` — PYNQ script to send inputs and read predictions from FPGA

## How It Works
1. Train the model using the notebook
2. Read the decision tree structure and manually encode it in Verilog
3. Deploy the bitstream to FPGA and run predictions via AXI GPIO
