module OR2 (
    input  b,       // First OR input
    input  c,       // Second OR input
    output q        // Output: q = b OR c
);
    // Simple 2-input OR gate implementation
    // Optimal PPA: single gate operation, no unused inputs
    assign q = b | c;
endmodule