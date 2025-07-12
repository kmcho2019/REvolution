module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
assign out_sop = (b &&!a &&!c &&!d) || 
                 (b &&!a && c && d) || 
                 (b && a && c && d);

// Minimum Product-of-Sums (POS) form for out_pos
// Using the principle of duality and simplification
assign out_pos = (b ||!a ||!c ||!d) && 
                 (b ||!a || c || d) && 
                 (a || b || c || d);

endmodule