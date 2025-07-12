module TopModule(
    input in1,
    input in2,
    output out
);

// Using a 4-input LUT (for simplicity, we'll directly implement the logic)
// The LUT's truth table will be programmed to implement the AND gate with an inverted input
assign out = (in1 & ~in2);

endmodule