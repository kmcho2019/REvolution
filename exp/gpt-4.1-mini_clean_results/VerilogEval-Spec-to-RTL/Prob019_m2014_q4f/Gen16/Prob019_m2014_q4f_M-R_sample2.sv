module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);

    // Direct continuous assignment implementing AND with bubble on in2 input
    assign out = in1 & (~in2);

endmodule