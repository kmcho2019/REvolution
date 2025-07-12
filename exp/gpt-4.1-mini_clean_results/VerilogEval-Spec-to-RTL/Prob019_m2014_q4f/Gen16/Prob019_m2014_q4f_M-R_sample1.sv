module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Implement the bubble on in2 by directly inverting in2 in the assign statement
    assign out = in1 & ~in2;
endmodule