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

    // Logic gate for when x[2] and x[3] are different
    wire gate_10;
    assign gate_10 = (x[2] & ~x[3] & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & ~x[1])) |
                     (x[2] & ~x[3] & x[0] & ~x[1]);

    // Combine the outputs of the LUTs and logic gate
    assign f = (~x[2] & ~x[3] & lut_00) |
               (x[2] & x[3] & lut_11) |
               gate_10;

endmodule