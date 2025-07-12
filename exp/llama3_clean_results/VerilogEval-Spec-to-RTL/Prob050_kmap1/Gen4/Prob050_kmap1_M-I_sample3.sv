// Given that the current implementation is already optimized for the functionality,
// the code remains largely the same. However, we could consider adding synthesis
// directives or constraints to encourage the tool to further optimize the design.
module TopModule(
    input a,
    input b,
    input c,
    output out
);

// The expression remains the same as it directly implements the required functionality.
assign out = a | b | c;

endmodule