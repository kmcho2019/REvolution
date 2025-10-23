module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Simplified computation by leveraging XOR properties
assign out = ((in1 ^ in2) == 1'b0) ^ in3;

// Alternatively, a more direct simplification using XOR properties
assign out = (in1 ^ in2 ^ in3) ^ in3;

// The most simplified form after applying XOR properties
assign out = in1 ^ in2 ^ in3;

endmodule