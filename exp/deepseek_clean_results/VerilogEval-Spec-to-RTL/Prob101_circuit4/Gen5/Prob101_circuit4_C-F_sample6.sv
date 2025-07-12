module TopModule (
    input a,       // Not used in logic (intentional)
    input b,       // OR operand 1
    input c,       // OR operand 2
    input d,       // Not used in logic (intentional)
    output q       // Output = b OR c
);
    // Output is 1 when either b or c is 1
    // Inputs a and d are intentionally ignored as per spec
    assign q = b | c;
endmodule