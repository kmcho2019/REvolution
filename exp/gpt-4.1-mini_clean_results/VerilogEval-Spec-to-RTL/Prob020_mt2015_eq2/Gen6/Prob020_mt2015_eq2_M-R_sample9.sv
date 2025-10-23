module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);
    // Perform bitwise XNOR between A and B bits and AND the results
    assign z = (A[1] ~^ B[1]) & (A[0] ~^ B[0]);
endmodule