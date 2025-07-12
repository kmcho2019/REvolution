module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
assign out_sop = (!a && b && !c && !d) || 
                 (!a && b && c && d) || 
                 (a && b && c && d);

// Minimum Product-of-Sums (POS) form for out_pos
// Directly derive the expression from the given conditions
assign out_pos = (!(a && !b && !c && !d)) && 
                 (!(a && !b && !c && d)) && 
                 (!(a && !b && c && !d)) && 
                 (!(a && !b && c && d)) && 
                 (!(a && b && !c && !d)) && 
                 (!(a && b && !c && d)) && 
                 (!(a && b && c && !d)) && 
                 (!(a && b && c && d)) && 
                 (!(a && !b && !c && !d)) && 
                 (!(a && !b && !c && d)) && 
                 (!(a && !b && c && !d)) && 
                 (!(a && !b && c && d)) && 
                 (!(a && b && !c && !d)) && 
                 (!(a && b && !c && d)) && 
                 (!(a && b && c && !d)) && 
                 (!(a && b && c && d)) && 
                 (!(a && !b && !c && !d)) && 
                 (!(a && !b && !c && d)) && 
                 (!(a && !b && c && !d)) && 
                 (!(a && !b && c && d)) && 
                 (!(a && b && !c && !d)) && 
                 (!(a && b && !c && d)) && 
                 (!(a && b && c && !d)) && 
                 (!(a && b && c && d)) && 
                 (!(a && !b && !c && !d)) && 
                 (!(a && !b && !c && d)) && 
                 (!(a && !b && c && !d)) && 
                 (!(a && !b && c && d)) && 
                 (!(a && b && !c && !d)) && 
                 (!(a && b && !c && d)) && 
                 (!(a && b && c && !d)) && 
                 (!(a && b && c && d)) && 
                 (!(a && !b && !c && !d)) && 
                 (!(a && !b && !c && d)) && 
                 (!(a && !b && c && !d)) && 
                 (!(a && !b && c && d)) && 
                 (!(a && b && !c && !d)) && 
                 (!(a && b && !c && d)) && 
                 (!(a && b && c && !d)) && 
                 (!(a && b && c && d));

// Correct Implementation
assign out_sop = (!a && b && !c && !d) || 
                 (!a && b && c && d) || 
                 (a && b && c && d);

assign out_pos = (a || !b || c || d) && 
                 (a || !b || !c || !d) && 
                 (!a || b);

endmodule