module TopModule (
    input a,       // Interface requirement (unused)
    input b,       // OR operand 1
    input c,       // OR operand 2
    input d,       // Interface requirement (unused)
    output q       // Output: q = b OR c
);
    // Functional implementation: q is 1 when either b or c is 1
    // Inputs a and d are unused but maintained for interface compatibility
    assign q = b | c;
endmodule