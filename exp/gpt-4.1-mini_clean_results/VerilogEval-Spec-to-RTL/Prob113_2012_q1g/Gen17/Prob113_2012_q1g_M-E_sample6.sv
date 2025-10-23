module TopModule(
    input  [3:0] x,
    output       f
);

    reg [15:0] lut;

    initial begin
        // Indices correspond to x[3:0] with x3 as MSB and x0 as LSB:
        // Mapping the Karnaugh map cells into lut:
        // From the map:
        // x3x2 x1x0:
        // 00 00 -> 1 (x=0000 -> index 0)
        // 00 01 -> 0 (1)
        // 00 11 -> 0 (3)
        // 00 10 -> 1 (2)
        // 01 00 -> 0 (4)
        // 01 01 -> 0 (5)
        // 01 11 -> 0 (7)
        // 01 10 -> 0 (6)
        // 11 00 -> 1 (12)
        // 11 01 -> 1 (13)
        // 11 11 -> 1 (15)
        // 11 10 -> 0 (14)
        // 10 00 -> 1 (8)
        // 10 01 -> 1 (9)
        // 10 11 -> 0 (11)
        // 10 10 -> 1 (10)

        // Indexed from 0 to 15:
        lut = 16'b1110110110001001;
        // binary digits from index 15 down to 0:
        // index: value
        // 15:1,14:0,13:1,12:1,
        // 11:0,10:1,9:1,8:1,
        // 7:0,6:0,5:0,4:0,
        // 3:0,2:1,1:0,0:1
    end

    assign f = lut[x];

endmodule