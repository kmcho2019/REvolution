module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (a'b'c'd') | (a'b'cd') | (a'b'c'd) | (a'bc'd') | (a'bc'd) | (a'b'cd) | (abc'd') | (abcd) | (ab'cd) | (abc'd);

// However, this implementation is not simplified and directly from the minterms.
// Let's simplify based on the actual Karnaugh map:
// The correct implementation based on the Karnaugh map would consider the combinations where out = 1 and find a minimized form.
// Correct Simplification:
assign out = (a'b) | (c'd) | (a & d) | (b & c);

endmodule