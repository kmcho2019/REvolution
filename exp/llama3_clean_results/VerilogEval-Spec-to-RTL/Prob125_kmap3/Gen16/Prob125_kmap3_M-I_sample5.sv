module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Original expression for reference: assign out = a | (~a & ~b & c);

// Considering an alternative expression that might simplify the logic or reduce gate count.
// However, given the current expression is already quite simplified and directly implements the required logic,
// significant improvements might be challenging without additional synthesis directives or technology-specific optimizations.

assign out = a ? 1'b1 : (b ? 1'b0 : c);

endmodule