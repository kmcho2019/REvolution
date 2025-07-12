module TopModule(
    input [1:0] A,
    input [1:0] B,
    output z
);

// Use a direct comparison for simplicity and efficiency
assign z = (A == B) ? 1'b1 : 1'b0;

endmodule