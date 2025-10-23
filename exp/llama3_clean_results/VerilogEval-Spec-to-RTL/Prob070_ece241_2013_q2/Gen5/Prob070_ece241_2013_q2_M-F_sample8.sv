module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products form for out_sop
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Minimum Product-of-Sums form for out_pos
assign out_pos = (a & b);

endmodule