module TopModule(
    input a,
    input b,
    input c,
    input d, // don't-care, ignored in logic
    output out
);

// Directly assign minimized Boolean expression:
// out = (~c & a) | (c & (~b | a))

assign out = (a & ~c) | (c & (~b | a));

endmodule