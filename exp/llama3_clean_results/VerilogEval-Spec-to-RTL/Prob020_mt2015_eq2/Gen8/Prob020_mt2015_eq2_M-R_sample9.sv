module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

// Direct comparison of A and B using logical expression
assign z = ~(A ^ B);

endmodule