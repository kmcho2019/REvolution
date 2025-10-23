module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
assign out_sop = (b && (!a && !c && !d)) || 
                 (b && !a && c && d) || 
                 (a && b && c && d);

// Deriving the product-of-sums form for out_pos directly
// out_pos is the complement of out_sop
assign out_pos = !(out_sop);

// Alternative implementation using a Karnaugh map
// assign out_sop = (b && (!a && !c && !d)) || 
//                  (b && !a && c && d) || 
//                  (a && b && c && d);
// assign out_pos = !((!b || (a && !c && !d) || (!a && !c && !d)) && 
//                   (!(b && !a && !c && !d) && !(b && !a && c && d) && !(a && b && c && d)));

endmodule