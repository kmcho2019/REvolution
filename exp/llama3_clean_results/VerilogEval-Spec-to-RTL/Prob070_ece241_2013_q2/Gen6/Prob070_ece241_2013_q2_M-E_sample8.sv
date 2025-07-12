module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
assign out_sop = (!a && !b && c && !d) || (!a && b && c && d) || (a && b && c && d);

// Deriving the product-of-sums form for out_pos directly
// Conditions for out_pos to be 0 are when inputs match 0, 1, 4, 5, 6, 9, 10, 13, or 14
// Thus, out_pos is 1 when the inputs do not match these conditions
assign out_pos = !((!a && !b && !c && !d) || (!a && !b && !c && d) || 
                  (!a && !b && c && !d) || (!a && !b && c && d) || 
                  (!a && b && !c && !d) || (!a && b && !c && d) || 
                  (!a && b && c && !d) || (a && !b && !c && d) || 
                  (a && !b && c && d) || (a && b && !c && d) || 
                  (a && b && c && !d));

endmodule