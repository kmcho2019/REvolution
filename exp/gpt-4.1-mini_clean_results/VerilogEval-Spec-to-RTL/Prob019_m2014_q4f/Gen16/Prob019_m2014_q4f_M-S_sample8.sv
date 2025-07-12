module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Directly assign out to AND of in1 and inverted in2
    assign out = in1 & ~in2;
endmodule