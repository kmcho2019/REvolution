module adder_4bit_cla (
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co,
    output Pg,
    output Gg
);
    wire [3:0] p, g;
    wire [4:0] c;
    
    assign p = a | b;
    assign g = a & b;
    assign c[0] = Cin;
    
    // Carry lookahead logic
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | 
                 (p[3] & p[2] & p[1] & p[0] & c[0]);
    
    assign y = a ^ b ^ c[3:0];
    assign Co = c[4];
    assign Pg = &p;
    assign Gg = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
endmodule

module adder_8bit_cla (
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire carry_mid;
    wire Pg0, Gg0, Pg1, Gg1;
    
    // Lower 4-bit CLA
    adder_4bit_cla adder_low (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(carry_mid),
        .Pg(Pg0),
        .Gg(Gg0)
    );
    
    // Upper 4-bit CLA
    adder_4bit_cla adder_high (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(carry_mid),
        .y(y[7:4]),
        .Co(Co),
        .Pg(Pg1),
        .Gg(Gg1)
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
    
    // Lower 8-bit CLA adder
    adder_8bit_cla adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_middle)
    );
    
    // Upper 8-bit CLA adder
    adder_8bit_cla adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_middle),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule