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

// 4-bit carry lookahead adder module using bit_full_adder
module cla_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    wire [3:0] p;   // propagate signals from bit adders
    wire [3:0] g;   // generate signals from bit adders
    wire [4:1] c;   // internal carry signals

    // Instantiate 4 bit full adders to get p/g and sum bits (sum temporarily with dummy cin, real sum later)
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : bitfa
            bit_full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(1'b0),   // temporary, real carry applied later
                .sum(),       // sum computed later with correct carry
                .p(p[i]),
                .g(g[i])
            );
        end
    endgenerate

    // Compute carry signals using CLA logic:
    // c[1] = g[0] + p[0]*cin
    // c[2] = g[1] + p[1]*c[1]
    // c[3] = g[2] + p[2]*c[2]
    // cout = c[4] = g[3] + p[3]*c[3]
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign cout = g[3] | (p[3] & c[3]);

    // Now that we have the carry inputs per bit, compute sums with correct carry-in
    // Bit 0 carry-in is cin, bit 1 carry-in is c[1], bit 2 is c[2], bit 3 is c[3]
    assign sum[0] = p[0] ^ cin;
    assign sum[1] = p[1] ^ c[1];
    assign sum[2] = p[2] ^ c[2];
    assign sum[3] = p[3] ^ c[3];
endmodule

// Top-level 8-bit adder using two 4-bit CLA blocks
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire c4; // carry between lower and upper 4-bit blocks

    // Lower 4 bits
    cla_4bit cla_lower (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .cout(c4)
    );

    // Upper 4 bits
    cla_4bit cla_upper (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(c4),
        .sum(sum[7:4]),
        .cout(cout)
    );
endmodule