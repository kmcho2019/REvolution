module adder_4bit_cla (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output g_group,
    output p_group
);
    wire [3:0] g = a & b;
    wire [3:0] p = a | b;
    wire [4:0] carry;
    
    // Carry lookahead logic
    assign carry[0] = cin;
    assign carry[1] = g[0] | (p[0] & carry[0]);
    assign carry[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & carry[0]);
    assign carry[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & carry[0]);
    assign carry[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
                     (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & carry[0]);
    
    assign sum = a ^ b ^ carry[3:0];
    assign g_group = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign p_group = p[3] & p[2] & p[1] & p[0];
endmodule

module adder_8bit_cla (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire g0, p0, g1, p1;
    wire carry_middle;
    
    // Lower 4-bit CLA
    adder_4bit_cla lower (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .g_group(g0),
        .p_group(p0)
    );
    
    // Upper 4-bit CLA
    adder_4bit_cla upper (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(carry_middle),
        .sum(sum[7:4]),
        .g_group(g1),
        .p_group(p1)
    );
    
    // Inter-group carry lookahead
    assign carry_middle = g0 | (p0 & cin);
    assign cout = g1 | (p1 & g0) | (p1 & p0 & cin);
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire g0, p0, g1, p1;
    wire carry_middle;
    
    // Lower 8-bit CLA
    adder_8bit_cla lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(carry_middle)
    );
    
    // Upper 8-bit CLA
    adder_8bit_cla upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_middle),
        .sum(y[15:8]),
        .cout(Co)
    );
endmodule