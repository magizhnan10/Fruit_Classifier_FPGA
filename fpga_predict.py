#!/usr/bin/env python
# coding: utf-8

# In[35]:


from pynq import Overlay
import time

ol = Overlay("design_6.bit")   # change name if needed

print("Overlay loaded ✅")

gpio_in  = ol.axi_gpio_0
gpio_out = ol.axi_gpio_1


# In[36]:


color_map = {
    "red": 0,
    "yellow": 1,
    "orange": 2,
    "green": 3
}

fruit_map = {
    0: "Apple",
    1: "Banana",
    2: "Orange",
    3: "Mango"
}


# In[42]:


def predict_fruit(color_str, height_cm, width_cm):

    if color_str not in color_map:
        print("Invalid color ❌")
        return

    color = color_map[color_str]

    # SCALE ×10 (VERY IMPORTANT)
    h = int(height_cm * 10)
    w = int(width_cm * 10)

    # PACK INTO 32-BIT
    value = (w << 16) | (h << 8) | color

    print("\n==========================")
    print("INPUT")
    print("==========================")
    print("Color:", color_str, "(", color, ")")
    print("Height:", h)
    print("Width :", w)
    print("Packed:", value)

    # SEND TO FPGA
    gpio_in.write(0, value)
    time.sleep(0.01)

    # READ OUTPUT
    result = gpio_out.read(0)

    print("\n==========================")
    print("OUTPUT")
    print("==========================")
    print("Raw FPGA:", result)
    print("Prediction:", fruit_map.get(result, "Unknown"))
    
    return result


# In[44]:


predict_fruit("yellow", 18, 4)   # Banana
predict_fruit("red", 7, 7)       # Apple
predict_fruit("orange", 6, 6)    # Orange
predict_fruit("black", 12, 6)    # Mango


# In[45]:


print("Sending:", value)
print("Reading:", gpio_out.read(0))


# In[46]:


print("Write test")
gpio_in.write(0, 12345)
time.sleep(0.01)
print("Read:", gpio_out.read(0))


# In[47]:


color = 3
h = 120
w = 60

value = (w << 16) | (h << 8) | color

gpio_in.write(0, value)
print(gpio_out.read(0))


# In[ ]:




