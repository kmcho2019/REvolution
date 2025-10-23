module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Direct implementation of SOP expression
assign out_sop = (!a & b & !c & !d) | (!a & b & c & d) | (a & b & c & d);

// Derivation of POS expression using K-map or other methods
// The correct POS expression should be:
assign out_pos = !( (!a & !b) | (!b & !c) | (!b & !d) | (a & !c & !d) );

endmodule