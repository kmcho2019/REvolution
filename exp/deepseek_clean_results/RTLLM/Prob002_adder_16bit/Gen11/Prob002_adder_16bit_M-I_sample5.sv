module carry_lookahead_4bit (
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co,
    output Pg,
    output Gg
);
    wire [3:0] g, p;
    wire [4:0] c;
    
    // Generate and propagate terms
    assign g = a & b;
    assign p = a | b;
    
    // Carry computation
    assign c[0] = Cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | 
                 (p[3] & p[2] & p[1] & p[0] & c[0]);
    
    // Sum and outputs
    assign y = a ^ b ^ c[3:0];
    assign Co = c[4];
    assign Pg = &p;
    assign Gg = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
endmodule

module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire [1:0] p, g;
    wire carry_middle;
    
    // Lower 4-bit CLA
    carry_lookahead_4bit cla_low (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(carry_middle),
        .Pg(p[0]),
        .Gg(g[0])
    );
    
    // Upper 4-bit CLA
    carry_lookahead_4bit cla_high (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(g[0] | (p[0] & Cin)),
        .y(y[7:4]),
        .Co(Co),
        .Pg(p[1]),
        .Gg(g[1])
    );
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [1:0] p, g;
    wire carry_middle;
    
    // Lower 8-bit adder
    adder_8bit adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_middle)
    );
    
    // Upper 8-bit adder
    adder_8bit adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_middle),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule