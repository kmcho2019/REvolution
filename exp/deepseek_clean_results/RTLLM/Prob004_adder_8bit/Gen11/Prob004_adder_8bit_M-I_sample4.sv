module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // 4-bit carry lookahead groups
    wire [1:0] g, p;  // Group generate/propagate
    wire [1:0] c;     // Group carry-out
    
    // First 4-bit block
    wire [3:0] g0, p0;
    assign g0[0] = a[0] & b[0];
    assign p0[0] = a[0] | b[0];
    assign sum[0] = a[0] ^ b[0] ^ cin;
    
    assign g0[1] = a[1] & b[1];
    assign p0[1] = a[1] | b[1];
    assign sum[1] = a[1] ^ b[1] ^ (g0[0] | (p0[0] & cin));
    
    assign g0[2] = a[2] & b[2];
    assign p0[2] = a[2] | b[2];
    assign sum[2] = a[2] ^ b[2] ^ (g0[1] | (p0[1] & g0[0]) | (p0[1] & p0[0] & cin));
    
    assign g0[3] = a[3] & b[3];
    assign p0[3] = a[3] | b[3];
    assign sum[3] = a[3] ^ b[3] ^ (g0[2] | (p0[2] & g0[1]) | (p0[2] & p0[1] & g0[0]) | 
                                  (p0[2] & p0[1] & p0[0] & cin));
    
    assign g[0] = g0[3] | (p0[3] & g0[2]) | (p0[3] & p0[2] & g0[1]) | 
                 (p0[3] & p0[2] & p0[1] & g0[0]);
    assign p[0] = p0[3] & p0[2] & p0[1] & p0[0];
    assign c[0] = g[0] | (p[0] & cin);
    
    // Second 4-bit block
    wire [3:0] g1, p1;
    assign g1[0] = a[4] & b[4];
    assign p1[0] = a[4] | b[4];
    assign sum[4] = a[4] ^ b[4] ^ c[0];
    
    assign g1[1] = a[5] & b[5];
    assign p1[1] = a[5] | b[5];
    assign sum[5] = a[5] ^ b[5] ^ (g1[0] | (p1[0] & c[0]));
    
    assign g1[2] = a[6] & b[6];
    assign p1[2] = a[6] | b[6];
    assign sum[6] = a[6] ^ b[6] ^ (g1[1] | (p1[1] & g1[0]) | (p1[1] & p1[0] & c[0]));
    
    assign g1[3] = a[7] & b[7];
    assign p1[3] = a[7] | b[7];
    assign sum[7] = a[7] ^ b[7] ^ (g1[2] | (p1[2] & g1[1]) | (p1[2] & p1[1] & g1[0]) | 
                                  (p1[2] & p1[1] & p1[0] & c[0]));
    
    assign g[1] = g1[3] | (p1[3] & g1[2]) | (p1[3] & p1[2] & g1[1]) | 
                 (p1[3] & p1[2] & p1[1] & g1[0]);
    assign p[1] = p1[3] & p1[2] & p1[1] & p1[0];
    assign c[1] = g[1] | (p[1] & c[0]);
    
    assign cout = c[1];

endmodule