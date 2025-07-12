module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized Boolean expression with factored common terms
assign out = !(
    (!a & d & (b ^ c)) |      // Combines terms 1, 2, and 3 using XOR
    (a & b & (c ^ d)) |       // Combines terms 4 and 6 using XOR
    (a & !b & c & !d)         // Term 5 remains
);

endmodule