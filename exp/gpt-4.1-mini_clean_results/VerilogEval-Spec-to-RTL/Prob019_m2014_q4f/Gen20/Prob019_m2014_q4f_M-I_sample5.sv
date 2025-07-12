module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Direct continuous assignment combining in1 and inverted in2
    // Implements the AND gate with a bubble on in2 with minimal hierarchy
    assign out = in1 & ~in2;
endmodule