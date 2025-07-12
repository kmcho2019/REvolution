module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Inline inversion of in2 and AND with in1
    assign out = in1 & ~in2;
endmodule