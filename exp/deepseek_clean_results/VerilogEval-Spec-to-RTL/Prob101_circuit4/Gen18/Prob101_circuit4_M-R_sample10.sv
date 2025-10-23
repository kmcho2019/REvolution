module TopModule (
    input a,       // Unused input (interface requirement)
    input b,       // OR input 1
    input c,       // OR input 2
    input d,       // Unused input (interface requirement)
    output q       // Output: q = b OR c
);
    // Direct OR implementation - simpler and more efficient
    assign q = b | c;
endmodule