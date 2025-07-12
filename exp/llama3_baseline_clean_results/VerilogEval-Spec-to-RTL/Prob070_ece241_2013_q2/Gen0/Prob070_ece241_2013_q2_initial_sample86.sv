module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form for logic-1 conditions
assign out_sop = (!a & !b & c & !d) | (!a & b & c & d) | (a & b & c & d);

// To find the Product-of-Sums (POS) form, first, identify the maxterms for the logic-0 conditions
// Then, use De Morgan's law and combine them with AND operators
assign out_pos = !( (a & b & c & !d) | (a & b & !c & d) | (a & !b & c & !d) | 
                  (!a & b & c & !d) | (!a & !b & !c & !d) | (!a & !b & !c & d) | 
                  (!a & b & !c & !d) | (!a & b & !c & d) | (!a & !b & c & !d) |
                  (a & !b & !c & d) );

endmodule