module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Applying the distributive property to potentially simplify the expression
assign out = a | (b & ~a) | (c & ~a);

endmodule