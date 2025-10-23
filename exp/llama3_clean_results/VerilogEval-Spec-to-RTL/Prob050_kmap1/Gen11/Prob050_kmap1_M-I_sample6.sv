module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Direct implementation using a ternary operator, which is already optimized
assign out = a ? 1'b1 : (b | c);

endmodule