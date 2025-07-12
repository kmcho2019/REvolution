// Define a parameterized NAND gate module for flexibility and reusability.
module ParamNAND(
    input  [3:0] inputs, // 4-input NAND gate
    output y
);
    assign y = ~(&inputs); // Perform NAND operation on all inputs

endmodule

// Implement the TopModule using two instances of the ParamNAND gate.
module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);
    // Group inputs into 4-bit vectors for the ParamNAND gates.
    wire [3:0] p1_inputs = {p1a, p1b, p1c, p1d};
    wire [3:0] p2_inputs = {p2a, p2b, p2c, p2d};

    // Instantiate ParamNAND gates for each set of inputs.
    ParamNAND nand1(
        .inputs(p1_inputs),
        .y(p1y)
    );

    ParamNAND nand2(
        .inputs(p2_inputs),
        .y(p2y)
    );

endmodule