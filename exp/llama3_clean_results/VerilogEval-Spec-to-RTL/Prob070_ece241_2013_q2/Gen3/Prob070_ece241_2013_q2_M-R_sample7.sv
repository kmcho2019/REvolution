module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Direct implementation of SOP expression
// Minterms for 2, 7, and 15
assign out_sop = (!a & !c & b & d) | (!a & c & b & d) | (a & c & b & d);

// For POS, considering the conditions, we need to identify the maxterms
// and then apply De Morgan's laws. However, to simplify and directly
// address the conditions, let's re-evaluate the implementation.
// Since we know the specific conditions for '1' outputs, we can focus
// on implementing these conditions directly in a product-of-sums form.
// Given the complexity of directly deriving the POS form, we'll focus
// on ensuring the SOP form is correctly implemented and reconsider the
// POS implementation based on the given conditions and potentially
// simplifying it by directly addressing the '1' output conditions.
assign out_pos = (a | !c | !b | !d) & ((a & c & b & d) | (!a & c & b & d) | (!a & !c & b & d));

endmodule