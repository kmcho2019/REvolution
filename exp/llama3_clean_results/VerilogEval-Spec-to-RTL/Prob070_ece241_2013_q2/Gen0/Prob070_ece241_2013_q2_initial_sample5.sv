module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
assign out_sop = (a &&!b && c &&!d) || 
                 (!a && b && c && d) || 
                 (a && b && c && d);

// Minimum Product-of-Sums (POS) form for out_pos
// Since the problem requires us to consider the direct implementation of POS,
// and given the specific conditions, we first identify maxterms for 0 conditions
// then apply De Morgan's laws for simplification. However, for simplicity and
// adherence to the problem's direct requirements, the POS form is derived based
// on the given conditions and the understanding that it represents the product
// of sums that must be true for the output to be 1.

assign out_pos =!( (!a &&!b &&!c &&!d) || 
                   (a &&!b &&!c &&!d) || 
                   (!a && b &&!c &&!d) || 
                   (!a &&!b && c &&!d) || 
                   (!a &&!b &&!c && d) || 
                   (a && b &&!c &&!d) || 
                   (a &&!b && c &&!d) || 
                   (a &&!b &&!c && d) || 
                   (!a && b && c &&!d) || 
                   (!a && b &&!c && d) || 
                   (!a &&!b && c && d) || 
                   (a &&!b && c && d) );

endmodule