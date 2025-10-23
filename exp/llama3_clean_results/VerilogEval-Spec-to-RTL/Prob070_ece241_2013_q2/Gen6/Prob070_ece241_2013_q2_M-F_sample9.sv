module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
// Correctly representing the conditions for 2, 7, and 15
assign out_sop = (!a && !b && c && !d) || (!a && b && c && d) || (a && b && c && d);

// Minimum Product-of-Sums (POS) form for out_pos
// Directly implementing the conditions for logic-0 outputs
assign out_pos = 
    (!(a || b || c || d)) || 
    (!(a || !b || !c || !d)) || 
    (!(a || b || !c || d) && !(a || b || c || !d)) || 
    (!(a || !b || c || d) && !(a || b || !c || d)) || 
    (!(a || !b || c || !d) && !(a || b || !c || d)) || 
    (!(a || b || c || !d) && !(a || !b || c || d)) || 
    (!(a || b || !c || !d) && !(a || !b || c || !d)) || 
    (!(a || !b || !c || d) && !(a || b || !c || d)) || 
    (!(a || !b || !c || !d) && !(a || b || c || !d));

endmodule