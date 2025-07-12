module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire sign_a = a[7];
    wire sign_b = b[7];
    wire sign_s;
    
    assign s = a + b;
    assign sign_s = s[7];
    
    // Optimized overflow detection using XOR and AND
    assign overflow = ~(sign_a ^ sign_b) & (sign_a ^ sign_s);
endmodule