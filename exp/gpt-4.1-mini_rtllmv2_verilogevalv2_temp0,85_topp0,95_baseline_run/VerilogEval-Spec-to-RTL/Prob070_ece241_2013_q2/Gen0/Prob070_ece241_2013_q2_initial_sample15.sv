module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimal Sum of Products for out_sop:
// out_sop = (b & c & d) | (~a & ~b & c & ~d)
assign out_sop = (b & c & d) | (~a & ~b & c & ~d);

// Minimal Product of Sums for out_pos:
// out_pos = (a + b + c + d) & (a + ~b + c + ~d) & (~a + b + ~c + ~d)
assign out_pos = (a | b | c | d) & (a | ~b | c | ~d) & (~a | b | ~c | ~d);

endmodule