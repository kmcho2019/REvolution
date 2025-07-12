// Single-bit full adder module with direct boolean assignments
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout,
    output wire p,    // propagate signal
    output wire g     // generate signal
);
    // sum is XOR of inputs and carry-in
    assign sum = a ^ b ^ cin;
    // carry-out is generate or propagate of carry-in
    assign cout = (a & b) | (b & cin) | (cin & a);
    // propagate: 1 if either a or b is 1, used for CLA
    assign p = a ^ b;
    // generate: 1 if both a and b are 1, used for CLA
    assign g = a & b;
endmodule

// 4-bit carry lookahead logic to compute carry-outs from propagate, generate, and input carry
module cla4_carry (
    input  wire [3:0] p,
    input  wire [3:0] g,
    input  wire       cin,
    output wire [4:1] c
);
    // Carry lookahead equations
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
endmodule

// 8-bit adder combining bit-level full adders and carry lookahead over two 4-bit blocks
module adder_8bit (
    input  wire [7:0] a,     // 8-bit operand A
    input  wire [7:0] b,     // 8-bit operand B
    input  wire       cin,   // carry-in input
    output wire [7:0] sum,   // 8-bit sum output
    output wire       cout   // carry-out output
);
    // Lower 4 bits signals
    wire [3:0] p_low, g_low, sum_low;
    wire [4:1] c_low;
    // Upper 4 bits signals
    wire [3:0] p_high, g_high, sum_high;
    wire [4:1] c_high;
    
    // Compute propagate and generate at bit-level for lower 4 bits
    bit_full_adder fa0 (
        .a(a[0]), .b(b[0]), .cin(cin),
        .sum(sum_low[0]), .cout(), .p(p_low[0]), .g(g_low[0])
    );
    bit_full_adder fa1 (
        .a(a[1]), .b(b[1]), .cin(c_low[1]),
        .sum(sum_low[1]), .cout(), .p(p_low[1]), .g(g_low[1])
    );
    bit_full_adder fa2 (
        .a(a[2]), .b(b[2]), .cin(c_low[2]),
        .sum(sum_low[2]), .cout(), .p(p_low[2]), .g(g_low[2])
    );
    bit_full_adder fa3 (
        .a(a[3]), .b(b[3]), .cin(c_low[3]),
        .sum(sum_low[3]), .cout(), .p(p_low[3]), .g(g_low[3])
    );

    // Compute propagate and generate for upper 4 bits
    bit_full_adder fa4 (
        .a(a[4]), .b(b[4]), .cin(c_high[1]),
        .sum(sum_high[0]), .cout(), .p(p_high[0]), .g(g_high[0])
    );
    bit_full_adder fa5 (
        .a(a[5]), .b(b[5]), .cin(c_high[2]),
        .sum(sum_high[1]), .cout(), .p(p_high[1]), .g(g_high[1])
    );
    bit_full_adder fa6 (
        .a(a[6]), .b(b[6]), .cin(c_high[3]),
        .sum(sum_high[2]), .cout(), .p(p_high[2]), .g(g_high[2])
    );
    bit_full_adder fa7 (
        .a(a[7]), .b(b[7]), .cin(c_high[4]),
        .sum(sum_high[3]), .cout(), .p(p_high[3]), .g(g_high[3])
    );

    // Lower 4-bit CLA carry calculation
    cla4_carry cla_low_carry (
        .p(p_low),
        .g(g_low),
        .cin(cin),
        .c(c_low)
    );

    // Compute carry-in for upper 4 bits using the carry-out of lower block (c_low[4])
    wire c4 = c_low[4];

    // Upper 4-bit CLA carry calculation
    // Note that cin for upper block is c4
    cla4_carry cla_high_carry (
        .p(p_high),
        .g(g_high),
        .cin(c4),
        .c(c_high)
    );

    // Final carry-out is carry-out from the upper block, i.e. c_high[4]
    assign cout = c_high[4];

    // Concatenate the sum bits
    assign sum = {sum_high, sum_low};
endmodule