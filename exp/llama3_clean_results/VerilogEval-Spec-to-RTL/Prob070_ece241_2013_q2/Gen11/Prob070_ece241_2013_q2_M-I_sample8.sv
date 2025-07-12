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
    // Generate the out_sop output in minimum sum-of-products form
    out_sop = (!a && b && !c && !d) || 
               (!a && b && c && d) || 
               (a && b && c && d);

    // Generate the out_pos output in minimum product-of-sums form
    out_pos = (b || c || d) && (a || b || c || d);
end

endmodule