module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Direct sum calculation
    assign s = a + b;
    
    // Overflow occurs when inputs have same sign but result has opposite sign
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);
endmodule