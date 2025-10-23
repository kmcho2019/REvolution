module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

// Directly compare the two 2-bit inputs A and B using the equality operator
assign z = (A == B);

endmodule