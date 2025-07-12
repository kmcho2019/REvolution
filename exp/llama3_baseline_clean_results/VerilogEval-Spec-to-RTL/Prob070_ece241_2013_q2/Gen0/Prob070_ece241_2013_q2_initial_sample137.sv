module TopModule(a, b, c, d, out_sop, out_pos);
    input a, b, c, d;
    output out_sop, out_pos;

    // Sum-of-Products (SOP) form
    // For numbers 2, 7, and 15
    assign out_sop = (!a & !b & c & !d) | (!a & b & c & d) | (a & b & c & d);

    // Product-of-Sums (POS) form
    // Since the conditions for 0 output are more complex, we first find the SOP for the complement of the output
    // Then apply De Morgan's law to get the POS form
    // The numbers that should produce a 0 are 0, 1, 4, 5, 6, 9, 10, 13, 14
    // But since the system doesn't care about inputs 3, 8, 11, 12, we only need to consider the given outputs
    // The complement conditions are not directly given, but we know the output should be 1 for 2, 7, 15
    // We'll find the SOP for the output being 0, then apply De Morgan's law
    assign out_pos = !( (!a & !b & !c & !d) | 
                       (!a & !b & !c & d) | 
                       (!a & !b & c & !d) | 
                       (!a & !b & c & d) | 
                       (!a & b & !c & !d) | 
                       (!a & b & !c & d) | 
                       (!a & b & c & !d) | 
                       (a & !b & !c & !d) | 
                       (a & !b & c & !d) );

    // Applying De Morgan's law to simplify out_pos (though this step is conceptually important, 
    // in practice, the direct application here results in a complex expression that isn't straightforward 
    // to simplify without additional context on how the don't-care conditions influence the result).
    // The expression for out_pos above directly represents the product-of-sums form after applying De Morgan's law
    // to the sum-of-products form of the complement of out_pos. However, simplification based on the given problem
    // statement's constraints and considering don't-care conditions is necessary for a minimal form.
endmodule