module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Directly implement AND with bubble on in2 using inline inversion
    assign out = in1 & ~in2;
endmodule