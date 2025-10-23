module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Direct equality comparison - synthesizes to optimal XNOR+AND structure
    assign z = (A == B);
endmodule