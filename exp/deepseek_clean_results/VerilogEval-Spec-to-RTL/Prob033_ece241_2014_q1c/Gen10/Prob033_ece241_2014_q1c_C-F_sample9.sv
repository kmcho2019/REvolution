module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Generate and propagate terms
    wire [7:0] g = a & b;
    wire [7:0] p = a ^ b;
    
    // Carry computation (ripple-carry with g/p terms)
    wire [7:0] c;
    assign c[0] = g[0];
    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & c[1]);
    assign c[3] = g[3] | (p[3] & c[2]);
    assign c[4] = g[4] | (p[4] & c[3]);
    assign c[5] = g[5] | (p[5] & c[4]);
    assign c[6] = g[6] | (p[6] & c[5]);
    assign c[7] = g[7] | (p[7] & c[6]);
    
    // Sum computation (XOR propagate with carry)
    assign s[0] = p[0];
    assign s[1] = p[1] ^ c[0];
    assign s[2] = p[2] ^ c[1];
    assign s[3] = p[3] ^ c[2];
    assign s[4] = p[4] ^ c[3];
    assign s[5] = p[5] ^ c[4];
    assign s[6] = p[6] ^ c[5];
    assign s[7] = p[7] ^ c[6];
    
    // Overflow detection (sign bits comparison)
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);
endmodule