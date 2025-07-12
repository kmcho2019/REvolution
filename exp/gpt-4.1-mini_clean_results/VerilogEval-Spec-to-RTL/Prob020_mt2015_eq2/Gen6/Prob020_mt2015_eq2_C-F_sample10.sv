module TopModule (
    input  wire [1:0] A,
    input  wire [1:0] B,
    output wire       z
);

    // Direct equality check for 2-bit vectors
    assign z = (A == B);

endmodule