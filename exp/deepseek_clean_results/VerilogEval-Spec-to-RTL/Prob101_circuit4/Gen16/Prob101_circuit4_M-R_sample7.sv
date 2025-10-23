module TopModule (
    input a,       // Unused input (interface requirement)
    input b,       // OR input 1
    input c,       // OR input 2
    input d,       // Unused input (interface requirement)
    output q       // Output: q = b OR c
);
    // Implementation note:
    // Output is 1 when either b or c is 1, matching given truth table
    // Inputs a and d are unused but kept for interface compliance
    
    // Continuous assignment using OR operator
    assign q = b | c;
endmodule