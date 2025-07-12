module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Sum-of-products (SOP) expression
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Derive the POS expression by applying De Morgan's laws
// Since we have the SOP expression for the desired conditions, 
// we can find the POS expression by inverting the SOP expression of the undesired conditions
// The undesired conditions are 0, 1, 4, 5, 6, 9, 10, 13, and 14
// However, we can simplify this by using the fact that the POS expression is the dual of the SOP expression
// So, we can use the maxterms corresponding to the undesired conditions
// But in this case, we can directly use the fact that the output should be 1 when the inputs are 2, 7, or 15
// And use the SOP expression to find the POS expression
assign out_pos = ~(~(~a & b & ~c & ~d) & ~(~a & b & c & d) & ~(a & b & c & d));

endmodule