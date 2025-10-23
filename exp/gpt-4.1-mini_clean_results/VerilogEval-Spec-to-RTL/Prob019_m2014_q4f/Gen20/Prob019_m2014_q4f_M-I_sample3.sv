module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);

    // out = in1 AND (NOT in2), reflecting the bubble on in2 input
    assign out = in1 & ~in2;

endmodule