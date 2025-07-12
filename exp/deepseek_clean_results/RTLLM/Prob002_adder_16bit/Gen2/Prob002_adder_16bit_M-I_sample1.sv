module adder_8bit_cla (
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire [7:0] g, p;  // generate and propagate terms
    wire [8:0] carry;
    
    assign carry[0] = Cin;
    
    // Generate and propagate terms
    assign g = a & b;
    assign p = a | b;
    
    // Carry-lookahead logic
    assign carry[1] = g[0] | (p[0] & carry[0]);
    assign carry[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & carry[0]);
    assign carry[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & carry[0]);
    assign carry[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
                     (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & carry[0]);
    assign carry[5] = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) |
                     (p[4] & p[3] & p[2] & g[1]) | (p[4] & p[3] & p[2] & p[1] & g[0]) |
                     (p[4] & p[3] & p[2] & p[1] & p[0] & carry[0]);
    assign carry[6] = g[5] | (p[5] & g[4]) | (p[5] & p[4] & g[3]) |
                     (p[5] & p[4] & p[3] & g[2]) | (p[5] & p[4] & p[3] & p[2] & g[1]) |
                     (p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) |
                     (p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & carry[0]);
    assign carry[7] = g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) |
                     (p[6] & p[5] & p[4] & g[3]) | (p[6] & p[5] & p[4] & p[3] & g[2]) |
                     (p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) |
                     (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) |
                     (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & carry[0]);
    assign carry[8] = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) |
                     (p[7] & p[6] & p[5] & g[4]) | (p[7] & p[6] & p[5] & p[4] & g[3]) |
                     (p[7] & p[6] & p[5] & p[4] & p[3] & g[2]) |
                     (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) |
                     (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) |
                     (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & carry[0]);
    
    // Sum calculation
    assign y = a ^ b ^ carry[7:0];
    assign Co = carry[8];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_middle;
    
    // Lower 8 bits with carry-lookahead
    adder_8bit_cla adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_middle)
    );
    
    // Upper 8 bits with carry-lookahead
    adder_8bit_cla adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_middle),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule