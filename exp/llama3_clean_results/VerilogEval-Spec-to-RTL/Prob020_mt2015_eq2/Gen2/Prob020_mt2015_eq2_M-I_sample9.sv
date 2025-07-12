module TopModule(
    input [1:0] A,
    input [1:0] B,
    output z
);

// Use a direct comparison for simplicity and efficiency
// The synthesis tool can further optimize this based on the technology library and input characteristics
assign z = (A == B) ? 1'b1 : 1'b0;

endmodule