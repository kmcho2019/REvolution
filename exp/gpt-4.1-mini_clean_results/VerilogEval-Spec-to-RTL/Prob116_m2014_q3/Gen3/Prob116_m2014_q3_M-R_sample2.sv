module TopModule (
    input  [3:0] x,
    output      f
);

    // Address formed as {x[3], x[0], x[1], x[2]}:
    // MSB: x[3]
    //      x[0]
    //      x[1]
    // LSB: x[2]
    wire [3:0] addr = {x[3], x[0], x[1], x[2]};

    // Karnaugh map (with rows = x[3]x[0], columns = x[1]x[2]):
    //
    //        x[1]x[2]
    // x[3]x[0] 00   01   11   10
    //    00   d     0    d    d
    //    01   0     d    1    0
    //    11   1     1    d    d
    //    10   1     1    0    d
    //
    // Assign don't-cares (d) to 0 or 1 to simplify:
    // For addr = {x[3], x[0], x[1], x[2]} from 0 to 15:
    //
    // addr (bin) | row(x3x0) | col(x1x2) | f (after choosing d)
    // -----------------------------------------------
    // 0000 (0)   | 00        | 00        | d -> 0
    // 0001 (1)   | 00        | 01        | 0
    // 0010 (2)   | 00        | 10        | d -> 0
    // 0011 (3)   | 00        | 11        | d -> 0
    //
    // 0100 (4)   | 01        | 00        | 0
    // 0101 (5)   | 01        | 01        | d -> 0
    // 0110 (6)   | 01        | 10        | 0
    // 0111 (7)   | 01        | 11        | 1
    //
    // 1000 (8)   | 10        | 00        | 1
    // 1001 (9)   | 10        | 01        | 1
    // 1010 (10)  | 10        | 10        | d -> 0
    // 1011 (11)  | 10        | 11        | 0
    //
    // 1100 (12)  | 11        | 00        | 1
    // 1101 (13)  | 11        | 01        | 1
    // 1110 (14)  | 11        | 10        | d -> 0
    // 1111 (15)  | 11        | 11        | d -> 0

    // Construct the LUT bits [15:0] with bit n = f(addr=n)
    // From the above:
    // addr: f
    // 0:0
    // 1:0
    // 2:0
    // 3:0
    // 4:0
    // 5:0
    // 6:0
    // 7:1
    // 8:1
    // 9:1
    // 10:0
    // 11:0
    // 12:1
    // 13:1
    // 14:0
    // 15:0

    // Binary for LUT[15:0] from addr=15 down to 0:
    // addr=15 to addr=0:
    // bit15=0
    // bit14=0
    // bit13=1
    // bit12=1
    // bit11=0
    // bit10=0
    // bit9=1
    // bit8=1
    // bit7=1
    // bit6=0
    // bit5=0
    // bit4=0
    // bit3=0
    // bit2=0
    // bit1=0
    // bit0=0

    // So bits [15:0] = 0011001110000000b = 16'h3380

    wire [15:0] lut = 16'h3380;

    assign f = lut[addr];

endmodule