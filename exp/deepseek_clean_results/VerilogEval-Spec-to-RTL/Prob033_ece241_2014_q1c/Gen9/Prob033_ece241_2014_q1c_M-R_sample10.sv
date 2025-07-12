module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Generate and propagate terms
    wire [7:0] g = a & b;
    wire [7:0] p = a ^ b;
    
    // Carry computation (4-bit blocks)
    wire [1:0] c_block;
    assign c_block[0] = g[0] | (p[0] & 1'b0);  // c[0]
    assign c_block[1] = g[1] | (p[1] & c_block[0]);
    
    wire [3:0] c;
    assign c[0] = c_block[0];
    assign c[1] = c_block[1];
    assign c[2] = g[2] | (p[2] & c[1]);
    assign c[3] = g[3] | (p[3] & c[2]);
    
    wire [7:4] c_upper;
    assign c_upper[4] = g[4] | (p[4] & c[3]);
    assign c_upper[5] = g[5] | (p[5] & c_upper[4]);
    assign c_upper[6] = g[6] | (p[6] & c_upper[5]);
    assign c_upper[7] = g[7] | (p[7] & c_upper[6]);
    
    // Sum computation
    assign s[0] = p[0] ^ 1'b0;
    assign s[1] = p[1] ^ c[0];
    assign s[2] = p[2] ^ c[1];
    assign s[3] = p[3] ^ c[2];
    assign s[4] = p[4] ^ c[3];
    assign s[5] = p[5] ^ c_upper[4];
    assign s[6] = p[6] ^ c_upper[5];
    assign s[7] = p[7] ^ c_upper[6];
    
    // Overflow detection
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);
endmodule