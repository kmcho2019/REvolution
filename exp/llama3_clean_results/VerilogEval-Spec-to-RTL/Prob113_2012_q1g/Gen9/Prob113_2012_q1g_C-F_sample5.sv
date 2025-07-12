module TopModule(
    input  [3:0] x,
    output       f
);

    // LUT for when x[2] and x[3] are both 0
    wire lut_00;
    assign lut_00 = (~x[0] & ~x[1]) | (x[0] & ~x[1]);

    // LUT for when x[2] and x[3] are both 1
    wire lut_11;
    assign lut_11 = (~x[0] & ~x[1]) | (~x[0] & x[1]) | (x[0] & x[1]);

    // LUT for when x[2] is 1 and x[3] is 0
    wire lut_10;
    assign lut_10 = (~x[0] & ~x[1]) | (~x[0] & x[1]) | (x[0] & ~x[1]);

    // Define intermediate signals for each condition
    wire cond_00;
    assign cond_00 = ~x[2] & ~x[3] & lut_00;

    wire cond_11;
    assign cond_11 = x[2] & x[3] & lut_11;

    wire cond_10;
    assign cond_10 = x[2] & ~x[3] & lut_10;

    // Combine the outputs of the LUTs and logic gates
    assign f = cond_00 | cond_11 | cond_10;

endmodule