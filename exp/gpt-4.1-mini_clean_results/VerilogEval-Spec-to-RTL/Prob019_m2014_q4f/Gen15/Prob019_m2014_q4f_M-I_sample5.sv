module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Directly implement AND with bubble (inversion) on in2
    assign out = in1 & ~in2;
endmodule