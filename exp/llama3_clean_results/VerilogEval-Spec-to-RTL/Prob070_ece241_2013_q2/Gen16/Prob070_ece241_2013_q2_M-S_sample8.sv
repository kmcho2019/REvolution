module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Simplified SOP expression
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Simplified POS expression using K-maps or systematic approach
// Since out_pos should be 1 when out_sop is 1, we can use the same conditions but in a POS form
assign out_pos = ~( (a | ~b | c | ~d) & (a | ~b | ~c | ~d) & (a | ~b | ~c | d) );

// Alternatively, we could directly derive out_pos from out_sop for simplicity
// assign out_pos = out_sop;

endmodule