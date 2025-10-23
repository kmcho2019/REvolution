module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Direct implementation of SOP expression
assign out_sop = (b & ~a & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Direct implementation of POS expression
assign out_pos = ~((~a & ~b & ~c & ~d) | (~a & ~b & c & ~d) | (~a & ~b & ~c & d) | (~a & b & ~c & ~d) | (~a & ~b & c & d) | (~a & b & ~c & d) | (a & ~b & ~c & ~d) | (a & ~b & c & ~d) | (a & ~b & ~c & d) | (a & b & ~c & ~d));

endmodule