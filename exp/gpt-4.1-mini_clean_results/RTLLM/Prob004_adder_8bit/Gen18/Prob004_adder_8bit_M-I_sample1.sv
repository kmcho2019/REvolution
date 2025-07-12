// Single bit full adder with propagate and generate outputs
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire p,    // propagate: a XOR b
    output wire g     // generate: a AND b
);
    assign p   = a ^ b;
    assign g   = a & b;
    assign sum = p ^ cin;
endmodule

// 8-bit carry lookahead adder using bit_full_adder and hierarchical carry lookahead
module cla_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] p;       // propagate signals
    wire [7:0] g;       // generate signals
    wire [8:1] c;       // internal carry signals (c[1] is carry into bit1)
    
    // Generate p and g from bit_full_adder (sum output unused here)
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : bitfa
            bit_full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(1'b0),    // cin=0 temporarily, sum not used here
                .sum(),        // sum computed later with actual carry
                .p(p[i]),
                .g(g[i])
            );
        end
    endgenerate

    // Group propagate and generate for lower 4 bits (bits 3:0)
    wire p0_3 = &p[3:0];                        // p0_3 = p0 & p1 & p2 & p3
    wire g0_3 = g[3] | (p[3] & g[2]) | (p[3]&p[2]&g[1]) | (p[3]&p[2]&p[1]&g[0]);

    // Group propagate and generate for upper 4 bits (bits 7:4)
    wire p4_7 = &p[7:4];                        // p4_7 = p4 & p5 & p6 & p7
    wire g4_7 = g[7] | (p[7] & g[6]) | (p[7]&p[6]&g[5]) | (p[7]&p[6]&p[5]&g[4]);

    // Compute carry signals hierarchically:
    // Carry into bit0 = cin (external)
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);   // carry out of bit3 / carry into bit4

    // Using group generate/propagate signals for upper nibble carry computation
    // carry into bit4 = c[4] (already computed)
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    assign c[8] = g[7] | (p[7] & c[7]);   // carry out

    // Compute sums with proper carry inputs
    // sum[i] = p[i] ^ carry_in[i]
    // carry_in[0] = cin
    assign sum[0] = p[0] ^ cin;
    assign sum[1] = p[1] ^ c[1];
    assign sum[2] = p[2] ^ c[2];
    assign sum[3] = p[3] ^ c[3];
    assign sum[4] = p[4] ^ c[4];
    assign sum[5] = p[5] ^ c[5];
    assign sum[6] = p[6] ^ c[6];
    assign sum[7] = p[7] ^ c[7];

    assign cout = c[8];
endmodule

// Top-level 8-bit adder using single 8-bit CLA block
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    cla_8bit cla_inst (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );
endmodule