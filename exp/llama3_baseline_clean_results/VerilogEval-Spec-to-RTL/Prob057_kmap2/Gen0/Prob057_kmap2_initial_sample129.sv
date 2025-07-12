module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// The simplified expression obtained from the Karnaugh map is:
// out = (a & b & ~c & ~d) | (~a & b & ~c & d) | (a & b & c & d) | (a & ~b & c & ~d) | (a & ~b & ~c & ~d) | (~a & b & c & d) | (~a & ~b & c & d) | (~a & ~b & ~c & d);
// However, a more optimized version using Karnaugh map simplification would be:
// out = (a & ~c & ~d) | (b & ~c & d) | (a & b & d) | (~a & b & c) | (~a & ~b & d);
assign out = (a & ~c & ~d) | (b & ~c & d) | (a & b & d) | (~a & b & c) | (~a & ~b & d);

endmodule