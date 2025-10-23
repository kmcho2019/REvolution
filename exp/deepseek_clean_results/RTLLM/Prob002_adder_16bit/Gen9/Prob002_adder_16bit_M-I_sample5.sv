module cla_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout,
    output group_prop,
    output group_gen
);
    wire [3:0] p, g;
    wire [4:0] c;
    
    assign p = a ^ b;  // propagate
    assign g = a & b;  // generate
    
    // Carry computation
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | 
                 (p[3] & p[2] & p[1] & p[0] & c[0]);
    
    assign sum = p ^ c[3:0];
    assign cout = c[4];
    assign group_prop = &p;
    assign group_gen = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
endmodule

module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire carry_middle;
    wire lower_prop, lower_gen;
    
    // Lower 4-bit CLA
    cla_4bit lower (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .cout(carry_middle),
        .group_prop(lower_prop),
        .group_gen(lower_gen)
    );
    
    // Upper 4-bit CLA
    cla_4bit upper (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(carry_middle),
        .sum(sum[7:4]),
        .cout(cout),
        .group_prop(),  // Not used
        .group_gen()    // Not used
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