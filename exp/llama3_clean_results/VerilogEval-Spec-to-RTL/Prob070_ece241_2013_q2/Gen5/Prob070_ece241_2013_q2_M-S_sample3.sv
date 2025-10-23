module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
assign out_sop = (!a && b && !c && !d) || (!a && b && c && d) || (a && b && c && d);

// Minimum Product-of-Sums (POS) form for out_pos
// Since out_pos is the complement of out_sop, we can simplify its implementation
assign out_pos = ~(out_sop);

endmodule