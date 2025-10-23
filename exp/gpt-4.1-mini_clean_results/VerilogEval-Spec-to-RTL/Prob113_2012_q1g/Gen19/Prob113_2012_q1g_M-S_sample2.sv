module TopModule(
    input  [3:0] x,
    output       f
);

    // Define a 16-bit lookup table where each bit corresponds to f for input x
    // Index x: f
    //  0:1, 1:0, 2:1, 3:0,
    //  4:0, 5:0, 6:0, 7:0,
    //  8:1, 9:1,10:1,11:0,
    // 12:1,13:1,14:1,15:0
    wire [15:0] lut = 16'b0111_1110_0000_0101;

    assign f = lut[x];

endmodule