module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum sum-of-products form for out_sop
assign out_sop = (!a && b && !c && d) || 
                 (!a && b && c && d) || 
                 (a && b && c && d);

// Minimum product-of-sums form for out_pos
// First, find the product of sums that produce a logic-0
// Then, apply De Morgan's law to get the POS form
assign out_pos = !( (!a && !b && !c && !d) || 
                   (!a && !b && !c && d) || 
                   (!a && !b && c && !d) || 
                   (!a && !b && c && d) || 
                   (!a && b && !c && !d) || 
                   (!a && b && !c && d) || 
                   (a && !b && !c && d) || 
                   (a && !b && c && !d) || 
                   (a && b && !c && d) );

endmodule