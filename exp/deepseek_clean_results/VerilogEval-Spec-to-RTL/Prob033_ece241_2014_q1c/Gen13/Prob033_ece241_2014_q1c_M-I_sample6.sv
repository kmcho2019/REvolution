module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [8:0] sum = {1'b0, a} + {1'b0, b};
    assign s = sum[7:0];
    
    // Overflow occurs when:
    // 1. Operands have same sign (a[7] == b[7])
    // 2. Result has different sign (s[7] != a[7])
    assign overflow = ~(a[7] ^ b[7]) & (a[7] ^ s[7]);
endmodule