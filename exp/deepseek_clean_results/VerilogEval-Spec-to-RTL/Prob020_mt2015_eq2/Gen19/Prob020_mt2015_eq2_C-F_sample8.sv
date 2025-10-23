module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Explicit bitwise equality comparison
    // Each bit pair compared with XNOR, final AND of results
    // This is what the == operator synthesizes to, but more explicit
    assign z = (A[1] ~^ B[1]) & (A[0] ~^ B[0]);
endmodule