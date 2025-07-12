module TopModule (
    input a,       // (* unused *) Input not used in logic (interface requirement)
    input b,       // OR input 1 (active high)
    input c,       // OR input 2 (active high)
    input d,       // (* unused *) Input not used in logic (interface requirement)
    output q       // Output: q = b OR c (matches given truth table)
);
    // Truth table implementation:
    // q = 1 when either b or c is 1, 0 otherwise
    // Inputs a and d are kept for interface compliance but don't affect output
    assign q = b | c;
endmodule