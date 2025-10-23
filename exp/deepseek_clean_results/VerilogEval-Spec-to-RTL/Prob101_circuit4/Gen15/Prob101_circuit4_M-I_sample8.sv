module TopModule (
    input  a,      // Unused input (tied low)
    input  b,      // OR operand 1
    input  c,      // OR operand 2
    input  d,      // Unused input (tied low)
    output q       // Output: b OR c
);
    // Functional implementation:
    // q is high when either b or c is high
    // a and d are unused and tied low to prevent switching activity
    assign q = b | c;
    assign a = 1'b0;
    assign d = 1'b0;
endmodule