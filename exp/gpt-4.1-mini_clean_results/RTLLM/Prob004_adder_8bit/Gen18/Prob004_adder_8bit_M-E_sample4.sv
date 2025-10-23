// Single-bit full adder module
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// 8-bit adder with hierarchical carry computation for faster carry propagation
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    // Internal signals for carry between bits
    wire c1, c2, c3, c4, c5, c6, c7;

    // Generate and propagate signals for each bit
    wire [7:0] g; // generate: g[i] = a[i]&b[i]
    wire [7:0] p; // propagate: p[i] = a[i]^b[i]

    assign g = a & b;
    assign p = a ^ b;

    // First level carries computed using carry lookahead logic
    // c0 = cin
    // c1 = g0 + p0*cin
    // c2 = g1 + p1*g0 + p1*p0*cin
    // c3 = g2 + p2*g1 + p2*p1*g0 + p2*p1*p0*cin
    // and so on up to c7

    wire c0 = cin;

    assign c1 = g[0] | (p[0] & c0);
    assign c2 = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c0);
    assign c3 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c0);
    assign c4 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) 
                | (p[3] & p[2] & p[1] & p[0] & c0);
    assign c5 = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]) 
                | (p[4] & p[3] & p[2] & p[1] & g[0]) 
                | (p[4] & p[3] & p[2] & p[1] & p[0] & c0);
    assign c6 = g[5] | (p[5] & g[4]) | (p[5] & p[4] & g[3]) | (p[5] & p[4] & p[3] & g[2])
                | (p[5] & p[4] & p[3] & p[2] & g[1]) 
                | (p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) 
                | (p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c0);
    assign c7 = g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | (p[6] & p[5] & p[4] & g[3])
                | (p[6] & p[5] & p[4] & p[3] & g[2])
                | (p[6] & p[5] & p[4] & p[3] & p[2] & g[1])
                | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0])
                | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c0);

    // Final carry out
    assign cout = g[7] | (p[7] & c7);

    // Sum computation using propagate and carries
    assign sum[0] = p[0] ^ c0;
    assign sum[1] = p[1] ^ c1;
    assign sum[2] = p[2] ^ c2;
    assign sum[3] = p[3] ^ c3;
    assign sum[4] = p[4] ^ c4;
    assign sum[5] = p[5] ^ c5;
    assign sum[6] = p[6] ^ c6;
    assign sum[7] = p[7] ^ c7;
endmodule