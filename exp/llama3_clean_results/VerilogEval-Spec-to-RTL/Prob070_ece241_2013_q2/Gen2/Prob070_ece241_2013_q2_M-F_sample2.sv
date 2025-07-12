module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

// Direct implementation of SOP expression
// Minterms for 2, 7, and 15
always @(a, b, c, d) begin
    out_sop = (!a & !c & b & d) | (!a & c & b & d) | (a & c & b & d);
    
    // POS implementation considering the conditions
    // This involves ensuring out_pos is 1 only when the conditions for SOP are met
    // Since POS is the complement of SOP for this specific problem context,
    // we can directly use the SOP condition to set out_pos, but ensure it's correctly
    // implemented as a product of sums.
    out_pos = !(a | !c | !b | !d) & !((!a & !c & !b & d) | (!a & !c & b & !d) | (!a & c & !b & d) | (!a & c & b & !d));
end

endmodule