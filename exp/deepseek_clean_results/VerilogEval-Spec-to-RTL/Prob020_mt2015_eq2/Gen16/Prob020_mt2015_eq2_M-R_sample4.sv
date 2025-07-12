module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Explicit bit-wise comparison using XNOR and AND reduction
    assign z = &(A ~^ B);
endmodule