module TopModule (
    input  a, b, c, d,  // a and d are don't-care inputs
    output q
);
    // Output is 1 when either b or c is 1 (OR operation)
    // As observed in truth table, a and d don't affect the output
    assign q = b | c;
endmodule