module TopModule (
    input a,
    input b,
    output out
);
    wire ab, a_nb, na_b, na_nb;
    wire pass_ab, pass_na_nb;
    
    // Generate all possible input combinations
    assign ab = a & b;
    assign a_nb = a & ~b;
    assign na_b = ~a & b;
    assign na_nb = ~a & ~b;
    
    // Transmission gate control signals
    assign pass_ab = ~(a_nb | na_b);
    assign pass_na_nb = ~(ab | na_b);
    
    // Transmission gate implementation
    assign out = pass_ab ? ab : 1'bz;
    assign out = pass_na_nb ? na_nb : 1'bz;
    
    // Default pull-down when no transmission gate is active
    pullup(out);
endmodule