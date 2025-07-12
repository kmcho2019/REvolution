module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Inline inversion of in2 with in1 ANDed, synthesis will optimize this efficiently
    assign out = in1 & ~in2;
endmodule