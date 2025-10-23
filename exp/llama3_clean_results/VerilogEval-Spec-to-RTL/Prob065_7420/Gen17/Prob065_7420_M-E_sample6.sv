// Define a parameterized NAND gate module
module NANDGate(
    parameter INPUT_WIDTH = 4, // Parameter for the number of inputs
    input  [INPUT_WIDTH-1:0] inputs, // Array-based input handling
    output reg output // Output of the NAND gate
);

// Iterative combinational logic implementation
always @(*) begin
    output = 1; // Initialize output to 1 (true)
    for (int i = 0; i < INPUT_WIDTH; i++) begin
        output = output & inputs[i]; // Iteratively combine inputs using NAND
    end
    output = ~output; // Invert the result to get NAND
end

endmodule

// Instantiate the NANDGate module within the TopModule
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

// Instantiate the NANDGate module for the first 4-input NAND gate
NANDGate #(.INPUT_WIDTH(4)) nand1(
    .inputs({p1a, p1b, p1c, p1d}), // Pass inputs as an array
    .output(p1y)
);

// Instantiate the NANDGate module for the second 4-input NAND gate
NANDGate #(.INPUT_WIDTH(4)) nand2(
    .inputs({p2a, p2b, p2c, p2d}), // Pass inputs as an array
    .output(p2y)
);

endmodule