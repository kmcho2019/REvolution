module NotGate #(parameter DELAY = 0) (
    input  wire a,
    output wire y
);
    // Structural inversion with optional delay for clarity and synthesis friendliness
    assign #(DELAY) y = ~a;
endmodule

module AndGate #(parameter DELAY = 0) (
    input  wire a,
    input  wire b,
    output wire y
);
    // Structural AND with optional delay for clarity and synthesis friendliness
    assign #(DELAY) y = a & b;
endmodule

module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Direct continuous assignment combining in1 and inverted in2
    // Implements the AND gate with a bubble on in2 with minimal hierarchy
    assign out = in1 & ~in2;

endmodule