module TopModule(
    input [1:0] A,
    input [1:0] B,
    output z
);

// The existing solution is already optimized for simplicity and readability.
// No changes are needed for the logic itself. 
assign z = (A == B);

endmodule