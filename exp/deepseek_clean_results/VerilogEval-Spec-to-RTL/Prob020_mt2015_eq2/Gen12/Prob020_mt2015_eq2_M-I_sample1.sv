module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Direct equality comparison - synthesis tool will choose optimal implementation
    assign z = (A == B);
endmodule