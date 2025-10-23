module adder_8bit_cla (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire [7:0] g, p;
    wire [8:0] carry;
    
    // Generate and Propagate signals
    assign g = a & b;
    assign p = a ^ b;
    
    // Carry lookahead logic
    assign carry[0] = cin;
    assign carry[1] = g[0] | (p[0] & carry[0]);
    assign carry[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & carry[0]);
    assign carry[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & carry[0]);
    assign carry[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | 
                     (p[3] & p[2] & p[1] & p[0] & carry[0]);
    assign carry[5] = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]) |
                     (p[4] & p[3] & p[2] & p[1] & g[0]) | (p[4] & p[3] & p[2] & p[1] & p[0] & carry[0]);
    assign carry[6] = g[5] | (p[5] & g[4]) | (p[5] & p[4] & g[3]) | (p[5] & p[4] & p[3] & g[2]) |
                     (p[5] & p[4] & p[3] & p[2] & g[1]) | (p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) |
                     (p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & carry[0]);
    assign carry[7] = g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | (p[6] & p[5] & p[4] & g[3]) |
                     (p[6] & p[5] & p[4] & p[3] & g[2]) | (p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) |
                     (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) | 
                     (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & carry[0]);
    assign carry[8] = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]) |
                     (p[7] & p[6] & p[5] & p[4] & g[3]) | (p[7] & p[6] & p[5] & p[4] & p[3] & g[2]) |
                     (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) |
                     (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) |
                     (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & carry[0]);
    
    // Sum calculation
    assign sum = p ^ carry[7:0];
    assign cout = carry[8];
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
    adder_8bit_cla lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(carry_middle)
    );

    // Upper 8-bit CLA adder
    adder_8bit_cla upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_middle),
        .sum(y[15:8]),
        .cout(Co)
    );
endmodule