module TopModule(
    input [1:0] A,
    input [1:0] B,
    output z
);

// Directly assign the result of the comparison to z
assign z = A == B;

endmodule