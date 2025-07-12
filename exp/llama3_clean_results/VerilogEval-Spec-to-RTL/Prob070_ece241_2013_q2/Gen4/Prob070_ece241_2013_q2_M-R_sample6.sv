module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Direct implementation of SOP expression
// Correct minterms for 2, 7, and 15
assign out_sop = (!a & b & !c & !d) | (!a & b & c & d) | (a & b & c & d);

// For POS, considering the complexity and potential for error in direct derivation,
// let's re-evaluate the implementation. We'll focus on ensuring the SOP form is correct
// and consider the relationship between SOP and POS to derive the POS expression.
assign out_pos = !( (a & !b & !c & !d) | 
                   (!a & !b & !c & !d) | 
                   (!a & !b & c & !d) | 
                   (!a & !b & c & d) | 
                   (a & !b & !c & !d) | 
                   (a & !b & !c & d) | 
                   (a & !b & c & !d) | 
                   (!a & b & !c & !d) | 
                   (!a & !b & !c & d) | 
                   (a & !b & c & d));

endmodule