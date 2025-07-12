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
    
    // Corrected POS implementation considering the conditions
    // The output should be 1 for the numbers 2, 7, and 15
    // We use the product-of-sums form directly for these conditions
    out_pos = (a || !a) && (c || !c) && b && d;
end

endmodule