module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Correct derivation of SOP expression
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Deriving POS expression by inverting SOP
assign out_pos = ~(out_sop);

endmodule