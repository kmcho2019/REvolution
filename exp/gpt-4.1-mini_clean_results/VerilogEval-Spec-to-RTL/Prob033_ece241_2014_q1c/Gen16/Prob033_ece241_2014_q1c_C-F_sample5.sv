module FourBitCLABlock (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout,
    output       p_group,  // group propagate
    output       g_group,  // group generate
    output       carry_into_msb // carry into MSB of this block (bit 3)
);
    wire [3:0] p; // propagate per bit
    wire [3:0] g; // generate per bit
    wire [4:0] c; // carries, c[0]=cin, c[4]=cout

    assign p = a ^ b;
    assign g = a & b;

    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    assign sum = p ^ c[3:0];
    assign cout = c[4];
    assign carry_into_msb = c[3];

    // group propagate: all bits propagate
    assign p_group = &p; // p[3]&p[2]&p[1]&p[0]
    // group generate: any generate or propagate chain generates carry
    assign g_group = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire lower_cout, upper_cout;
    wire lower_p_group, lower_g_group;
    wire upper_p_group, upper_g_group;
    wire [3:0] lower_sum, upper_sum;
    wire carry_into_upper;       // carry in to upper 4-bit block
    wire carry_into_upper_msb;   // carry into MSB (bit 7)
    
    // Lower 4-bit CLA block (bits 3:0)
    FourBitCLABlock lower_block (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b0),
        .sum(lower_sum),
        .cout(lower_cout),
        .p_group(lower_p_group),
        .g_group(lower_g_group),
        .carry_into_msb() // unused here
    );

    // Calculate carry into upper block using group propagate and generate of lower block
    // carry_into_upper = g_lower | (p_lower & cin) but cin=0 => carry_into_upper = g_lower
    assign carry_into_upper = lower_g_group;

    // Upper 4-bit CLA block (bits 7:4)
    FourBitCLABlock upper_block (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(carry_into_upper),
        .sum(upper_sum),
        .cout(upper_cout),
        .p_group(upper_p_group),
        .g_group(upper_g_group),
        .carry_into_msb(carry_into_upper_msb)
    );

    assign s = {upper_sum, lower_sum};

    // Overflow = carry into MSB (bit 7) xor carry out of MSB (bit 7)
    assign overflow = carry_into_upper_msb ^ upper_cout;

endmodule