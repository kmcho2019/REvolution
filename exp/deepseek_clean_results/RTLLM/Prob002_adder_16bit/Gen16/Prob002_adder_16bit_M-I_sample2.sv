module adder_4bit_cla (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout,
    output g,
    output p
);
    wire [3:0] g_wire, p_wire;
    wire [4:0] carry;
    
    // Generate and propagate terms
    assign g_wire = a & b;
    assign p_wire = a | b;
    
    // Carry lookahead logic
    assign carry[0] = cin;
    assign carry[1] = g_wire[0] | (p_wire[0] & carry[0]);
    assign carry[2] = g_wire[1] | (p_wire[1] & g_wire[0]) | (p_wire[1] & p_wire[0] & carry[0]);
    assign carry[3] = g_wire[2] | (p_wire[2] & g_wire[1]) | (p_wire[2] & p_wire[1] & g_wire[0]) | 
                     (p_wire[2] & p_wire[1] & p_wire[0] & carry[0]);
    assign carry[4] = g_wire[3] | (p_wire[3] & g_wire[2]) | (p_wire[3] & p_wire[2] & g_wire[1]) |
                     (p_wire[3] & p_wire[2] & p_wire[1] & g_wire[0]) | 
                     (p_wire[3] & p_wire[2] & p_wire[1] & p_wire[0] & carry[0]);
    
    // Sum and outputs
    assign sum = a ^ b ^ carry[3:0];
    assign cout = carry[4];
    assign g = g_wire[3] | (p_wire[3] & g_wire[2]) | (p_wire[3] & p_wire[2] & g_wire[1]) |
              (p_wire[3] & p_wire[2] & p_wire[1] & g_wire[0]);
    assign p = &p_wire;
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
    adder_4bit_cla lower_adder (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .cout(carry_middle),
        .g(g0),
        .p(p0)
    );
    
    // Upper 4-bit CLA
    adder_4bit_cla upper_adder (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(carry_middle),
        .sum(sum[7:4]),
        .cout(cout),
        .g(g1),
        .p(p1)
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