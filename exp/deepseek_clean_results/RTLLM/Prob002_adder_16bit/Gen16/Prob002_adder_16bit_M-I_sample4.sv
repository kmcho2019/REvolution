module cla_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout,
    output g_group,
    output p_group
);
    wire [3:0] g, p;
    wire [4:1] c;
    
    // Generate and propagate terms
    assign g = a & b;
    assign p = a | b;
    
    // Carry lookahead logic
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | 
                 (p[3] & p[2] & p[1] & p[0] & cin);
    
    // Sum calculation
    assign sum = a ^ b ^ {c[3:1], cin};
    
    // Group outputs
    assign cout = c[4];
    assign g_group = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign p_group = &p;
endmodule

module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire g0, p0, g1, p1;
    wire carry_middle;
    
    // Lower 4-bit CLA
    cla_4bit lower (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .cout(carry_middle),
        .g_group(g0),
        .p_group(p0)
    );
    
    // Upper 4-bit CLA
    cla_4bit upper (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(carry_middle),
        .sum(sum[7:4]),
        .cout(cout),
        .g_group(g1),
        .p_group(p1)
    );
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_middle;
    
    // Lower 8-bit adder
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(carry_middle)
    );
    
    // Upper 8-bit adder
    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_middle),
        .sum(y[15:8]),
        .cout(Co)
    );
endmodule