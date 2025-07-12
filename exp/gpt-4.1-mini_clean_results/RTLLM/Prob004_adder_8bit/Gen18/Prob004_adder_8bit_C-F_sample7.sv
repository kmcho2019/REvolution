// Single-bit full adder with minimal sum and carry logic plus internal propagate and generate signals
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire p,    // propagate = a XOR b
    output wire g     // generate = a AND b
);
    wire axb;
    assign axb = a ^ b;
    assign sum = axb ^ cin;
    assign p   = axb;
    assign g   = a & b;
endmodule

// 4-bit carry lookahead adder using bit_full_adder instances
module cla_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    wire [3:0] p, g;       // propagate and generate signals from bit_full_adders
    wire [4:0] c;          // carry signals, c[0] = cin

    assign c[0] = cin;

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : gen_fa
            bit_full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(c[i]),
                .sum(sum[i]),
                .p(p[i]),
                .g(g[i])
            );
        end
    endgenerate

    // Carry look-ahead logic for 4-bit block
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    assign cout = c[4];
endmodule

// Top-level 8-bit adder using two 4-bit CLA blocks
module adder_8bit (
    input  wire [7:0] a,    // 8-bit operand A
    input  wire [7:0] b,    // 8-bit operand B
    input  wire       cin,  // carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // carry-out output
);
    wire c4;  // carry between lower and upper 4-bit CLA blocks

    // Lower 4-bit CLA block (bits 0 to 3)
    cla_4bit cla_low (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .cout(c4)
    );

    // Upper 4-bit CLA block (bits 4 to 7)
    cla_4bit cla_high (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(c4),
        .sum(sum[7:4]),
        .cout(cout)
    );
endmodule