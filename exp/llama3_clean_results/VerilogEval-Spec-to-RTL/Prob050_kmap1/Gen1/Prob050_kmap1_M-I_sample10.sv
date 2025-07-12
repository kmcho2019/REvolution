module TopModule(
    input a,
    input b,
    input c,
    output out
);

// The expression is already optimized for a simple OR operation.
assign out = a | b | c;

endmodule