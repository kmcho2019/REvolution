module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Equality check using bitwise XNOR operator, then AND both bits
assign z = (A[0] ~^ B[0]) & (A[1] ~^ B[1]);

endmodule