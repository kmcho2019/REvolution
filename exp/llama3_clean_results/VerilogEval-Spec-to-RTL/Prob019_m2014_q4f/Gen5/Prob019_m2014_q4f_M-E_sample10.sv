// TopModule: A digital circuit implementing an AND gate with one inverted input using a lookup table.
module TopModule(
    input  in1,  // First input to the AND gate.
    input  in2,  // Second input to the AND gate, inverted.
    output out    // Output of the AND gate.
);

// Define a wire to hold the inverted input.
wire in2_inv;

// Invert the second input.
assign in2_inv = ~in2;

// Use a lookup table (LUT) to implement the AND gate.
// The LUT is essentially a truth table that defines the output for all possible input combinations.
// In this case, we want out to be true only when in1 is true and in2_inv is true.
assign out = in1 & in2_inv;

endmodule