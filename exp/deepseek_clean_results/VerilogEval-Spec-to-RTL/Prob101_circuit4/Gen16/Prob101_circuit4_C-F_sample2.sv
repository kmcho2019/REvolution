module TopModule (
    input  a,       // Unused input (interface requirement)
    input  b,       // OR operand 1
    input  c,       // OR operand 2
    input  d,       // Unused input (interface requirement)
    output q        // Output: b OR c
);
    // Implementation:
    // Output is the logical OR of b and c
    // Inputs a and d are unused but maintained for interface compliance
    
    assign q = b | c;
endmodule