module TopModule(
    input a,
    input b,
    input c,
    input d,
    output reg out_sop,
    output reg out_pos
);

// Implementing the minimum sum-of-products form for out_sop
// Directly considering the valid conditions
always @(*)
begin
    out_sop = (b && !a && !c && !d) || 
               (!a && b && c && d) || 
               (a && b && c && d);
end

// Implementing the minimum product-of-sums form for out_pos
// Directly considering the valid conditions
always @(*)
begin
    out_pos = (!(a && !b && !c && !d) && 
               !(a && b && !c && !d) && 
               !(a && !b && c && !d) && 
               !(a && !b && !c && d) && 
               !(a && b && c && !d) && 
               !(a && b && !c && d) && 
               !(a && !b && c && d) && 
               !(a && b && !c && !d) && 
               !(!a && !b && !c && !d) && 
               !(!a && b && !c && !d) && 
               !(!a && !b && c && !d) && 
               !(!a && !b && !c && d) && 
               !(!a && b && c && !d) && 
               !(!a && b && !c && d) && 
               !(!a && !b && c && d));
end

endmodule