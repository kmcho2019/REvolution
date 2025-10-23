module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Simplified logic based on the Karnaugh map
// The output is 1 for the following conditions:
// - When a and b are 0 (a'b)
// - When c and d are different (c'd or c~d or ~c'd or c~d')
// - When a and d are both 1 (a&d)
// - When b and c are both 1 (b&c)
// Combining these conditions into a single expression:
assign out = (~a & ~b) | (~c & d) | (c & ~d) | (a & d) | (b & c);

endmodule