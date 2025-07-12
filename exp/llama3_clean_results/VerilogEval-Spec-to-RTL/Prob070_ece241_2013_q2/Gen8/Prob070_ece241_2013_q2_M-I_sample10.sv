module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
assign out_sop = (!a &&!b && c &&!d) || 
                 (!a && b && c && d) || 
                 (a && b && c && d);

// Minimum Product-of-Sums (POS) form for out_pos
// Since out_pos is the inverse of out_sop for the given input conditions
assign out_pos =!out_sop;

endmodule