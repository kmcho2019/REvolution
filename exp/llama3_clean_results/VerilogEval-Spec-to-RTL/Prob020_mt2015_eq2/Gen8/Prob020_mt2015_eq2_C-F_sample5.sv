module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

// Directly compare A and B using the equality operator in an assign statement
assign z = A == B;

endmodule