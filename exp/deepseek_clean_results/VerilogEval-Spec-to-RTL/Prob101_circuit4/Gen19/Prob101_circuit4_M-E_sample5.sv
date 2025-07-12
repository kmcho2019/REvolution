module TopModule (input a, b, c, d, output q);
    // Hierarchical decision tree implementation
    // b has priority over c, a and d are don't-cares
    assign q = b ? 1'b1 : (c ? 1'b1 : 1'b0);
endmodule