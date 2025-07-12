module TopModule(
    input a,
    input b,
    input c,
    output out
);

// The expression remains the same as it directly implements the required logic
// with minimal operations, which should be optimal for area and power.
assign out = a | b | c;

endmodule