module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Compute bitwise difference between A and B
wire diff0 = A[0] ^ B[0];
wire diff1 = A[1] ^ B[1];

// Output 'z' is high only if both bits are equal (no difference bits set)
assign z = ~(diff0 | diff1);

endmodule