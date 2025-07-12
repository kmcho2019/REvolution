module adder_4bit_cla (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [3:0] g, p;
    wire [3:0] carry;
    
    // Generate and propagate signals
    assign g = a & b;
    assign p = a ^ b;
    
    // Carry computation
    assign carry[0] = cin;
    assign carry[1] = g[0] | (p[0] & cin);
    assign carry[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign carry[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    assign cout = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | 
                 (p[3] & p[2] & p[1] & p[0] & cin);
    
    // Sum computation
    assign sum = p ^ carry;
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [3:0] carry;
    
    // 4-bit CLA blocks with carry lookahead between blocks
    adder_4bit_cla block0 (a[3:0],   b[3:0],  Cin,       y[3:0],   carry[0]);
    adder_4bit_cla block1 (a[7:4],   b[7:4],  carry[0],  y[7:4],   carry[1]);
    adder_4bit_cla block2 (a[11:8],  b[11:8], carry[1],  y[11:8],  carry[2]);
    adder_4bit_cla block3 (a[15:12], b[15:12],carry[2],  y[15:12], Co);
endmodule