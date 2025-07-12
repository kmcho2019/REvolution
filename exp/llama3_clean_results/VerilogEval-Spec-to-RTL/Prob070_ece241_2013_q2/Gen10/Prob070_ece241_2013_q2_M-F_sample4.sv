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
    out_sop = (!a && b &&!c &&!d) || (!a && b && c && d) || (a && b && c && d);

    // Minimum product-of-sums form for out_pos
    // Corrected implementation
    out_pos = (b) && ((d) || ((!d) && (!a)));
end

endmodule