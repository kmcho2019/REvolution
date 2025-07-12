module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
assign out_sop = (!a & b & !c & !d) || (!a & b & c & d) || (a & b & c & d);

// Deriving out_pos as the complement of out_sop
assign out_pos = ~out_sop;

endmodule