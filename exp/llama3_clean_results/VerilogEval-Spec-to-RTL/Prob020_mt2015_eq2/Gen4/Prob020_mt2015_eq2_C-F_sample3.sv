module TopModule(
    input [1:0] A,
    input [1:0] B,
    output z
);

// Direct comparison approach for simplicity and efficiency
assign z = A == B;

endmodule