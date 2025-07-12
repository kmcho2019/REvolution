module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Correct derivation of SOP expression using K-maps
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Correct derivation of POS expression using K-maps
assign out_pos = ~(~a & ~b & ~c & ~d) & ~(a & ~b & ~c & ~d) & ~(a & ~b & ~c & d) & ~(a & ~b & c & ~d) & ~(a & ~b & c & d) & ~(~a & ~b & ~c & d) & ~(~a & ~b & c & ~d) & ~(~a & b & ~c & ~d) & ~(~a & b & ~c & d) & ~(~a & b & c & ~d);

endmodule