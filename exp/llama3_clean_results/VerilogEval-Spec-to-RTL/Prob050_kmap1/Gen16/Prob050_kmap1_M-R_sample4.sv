module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Refactored implementation using logical operations directly
// out is 1 if a is 1, or if b or c is 1 when a is 0
assign out = a | (b & c) | (b & ~a) | (c & ~a);

// Alternatively, simplifying the expression based on the Karnaugh map's logic
// out is 1 if a is 1, or if b or c is 1 (regardless of a's value)
assign out = a | b | c;

endmodule