module TopModule (
    input  [3:0] x,
    output      f
);

    // Form address from inputs as per the K-map:
    // row bits = x[3], x[0]
    // column bits = x[1], x[2]
    wire [3:0] addr = {x[3], x[0], x[1], x[2]};

    /*
    Karnaugh Map (rows x columns):

         x[1]x[2]
    x[3]x[0]  00  01  11  10
       00    d    0    d    d
       01    0    d    1    0
       11    1    1    d    d
       10    1    1    0    d

    Assign don't-cares (d) = 0 for simplicity:

    Now, list all addr (row= x[3]x[0], col = x[1]x[2]) and f:

    addr (bin) = {x[3], x[0], x[1], x[2]} = row-col

    0:  0 0 0 0 -> row=00 col=00 -> d=0
    1:  0 0 0 1 -> row=00 col=01 -> 0
    2:  0 0 1 0 -> row=00 col=10 -> d=0
    3:  0 0 1 1 -> row=00 col=11 -> d=0

    4:  0 1 0 0 -> row=01 col=00 -> 0
    5:  0 1 0 1 -> row=01 col=01 -> d=0
    6:  0 1 1 0 -> row=01 col=10 -> 0
    7:  0 1 1 1 -> row=01 col=11 -> 1

    8:  1 1 0 0 -> row=11 col=00 -> 1
    9:  1 1 0 1 -> row=11 col=01 -> 1
    10: 1 1 1 0 -> row=11 col=10 -> d=0
    11: 1 1 1 1 -> row=11 col=11 -> d=0

    12: 1 0 0 0 -> row=10 col=00 -> 1
    13: 1 0 0 1 -> row=10 col=01 -> 1
    14: 1 0 1 0 -> row=10 col=10 -> d=0
    15: 1 0 1 1 -> row=10 col=11 -> 0

    LUT bits mapping (bit position = addr):
    bit : value (f)
    0  : 0
    1  : 0
    2  : 0
    3  : 0
    4  : 0
    5  : 0
    6  : 0
    7  : 1
    8  : 1
    9  : 1
    10 : 0
    11 : 0
    12 : 1
    13 : 1
    14 : 0
    15 : 0

    LUT = 16'b 0000_1100_0111_0000
             bit15             bit0

    In binary, bit15..bit0:
    bit15=0
    bit14=0
    bit13=1
    bit12=1
    bit11=0
    bit10=0
    bit9= 1
    bit8= 1
    bit7= 1
    bit6= 0
    bit5= 0
    bit4= 0
    bit3= 0
    bit2= 0
    bit1= 0
    bit0= 0

    So 16'b0000_1100_1110_0000

    However, counting bits carefully:

    bit0= addr=0 = 0
    bit1= addr=1 = 0
    bit2= addr=2 = 0
    bit3= addr=3 = 0
    bit4= addr=4 = 0
    bit5= addr=5 = 0
    bit6= addr=6 = 0
    bit7= addr=7 = 1
    bit8= addr=8 = 1
    bit9= addr=9 = 1
    bit10=addr=10=0
    bit11=addr=11=0
    bit12=addr=12=1
    bit13=addr=13=1
    bit14=addr=14=0
    bit15=addr=15=0

    Let's write bit15 down to bit0:

    bit15(15) = 0
    bit14(14) = 0
    bit13(13) = 1
    bit12(12) = 1
    bit11(11) = 0
    bit10(10) = 0
    bit9 (9)  = 1
    bit8 (8)  = 1
    bit7 (7)  = 1
    bit6 (6)  = 0
    bit5 (5)  = 0
    bit4 (4)  = 0
    bit3 (3)  = 0
    bit2 (2)  = 0
    bit1 (1)  = 0
    bit0 (0)  = 0

    So the binary literal is: 16'b0011_0011_1000_0000 == 16'h3380

    Let's double check bits:

    bit15 bit14 bit13 bit12   bit11 bit10 bit9 bit8    bit7 bit6 bit5 bit4  bit3 bit2 bit1 bit0
      0     0    1     1       0     0    1    1      1    0    0    0    0    0    0    0

    But above is 0 0 1 1 0 0 1 1 1 0 0 0 0 0 0 0 -> 16'b 0011_0011_1000_0000 = 0x3380

    We need to confirm with the previous bit7=1, bit8=1, bit9=1. Bit9=1 corresponds to addr=9.

    bit9= addr=9=1 correct.

    So this matches.

    Therefore, use: lut = 16'h3380;

    */

    wire [15:0] lut = 16'h3380;

    assign f = lut[addr];

endmodule