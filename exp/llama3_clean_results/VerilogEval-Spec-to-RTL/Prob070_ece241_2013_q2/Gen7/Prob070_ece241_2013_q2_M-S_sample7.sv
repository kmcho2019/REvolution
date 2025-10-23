module TopModule(
    input a,
    input b,
    input c,
    input d,
    output reg out_sop,
    output reg out_pos
);

always @(*)
begin
    // Minimum sum-of-products form for out_sop
    out_sop = (b && !a && !c && !d) || (!a && b && c && d) || (a && b && c && d);

    // Minimum product-of-sums form for out_pos
    // The logic for out_pos is the complement of the sum-of-products form for the numbers 0, 1, 4, 5, 6, 9, 10, 13, 14
    // Applying De Morgan's laws to simplify
    out_pos = !((!a && !b && !c && !d) || (a && !b && !c && !d) || 
               (!a && b && !c && !d) || (!a && !b && c && !d) || 
               (!a && !b && !c && d) || (!a && b && c && !d) || 
               (!a && b && !c && d) || (!a && !b && c && d) || 
               (a && b && !c && !d) || (a && !b && c && !d) || 
               (a && !b && !c && d));
end

endmodule