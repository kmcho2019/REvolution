// Define a module for a 4-input NAND gate using bitwise operations
module NAND4(
    input  [3:0] inputs,
    output        output
);

// Perform a bitwise AND operation on all bits of the input vector
assign output = ~(inputs[0] & inputs[1] & inputs[2] & inputs[3]);

endmodule

// Define the TopModule that instantiates two NAND4 gates
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

// Create input vectors for the NAND gates
wire [3:0] p1_inputs = {p1a, p1b, p1c, p1d};
wire [3:0] p2_inputs = {p2a, p2b, p2c, p2d};

// Instantiate the NAND4 modules
NAND4 nand1(
    .inputs(p1_inputs),
    .output(p1y)
);

NAND4 nand2(
    .inputs(p2_inputs),
    .output(p2y)
);

endmodule