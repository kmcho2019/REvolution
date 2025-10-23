module cla_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [3:0] g, p;
    wire [4:0] c;
    
    // Generate and propagate signals
    assign g = a & b;
    assign p = a ^ b;
    
    // Carry computation
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | 
                 (p[3] & p[2] & p[1] & p[0] & c[0]);
    
    // Sum computation
    assign sum = p ^ c[3:0];
    assign cout = c[4];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [3:0] carry;
    
    // 4-bit CLA blocks with carry lookahead between groups
    cla_4bit adder0 (.a(a[3:0]), .b(b[3:0]), .cin(Cin), .sum(y[3:0]), .cout(carry[0]));
    cla_4bit adder1 (.a(a[7:4]), .b(b[7:4]), .cin(carry[0]), .sum(y[7:4]), .cout(carry[1]));
    cla_4bit adder2 (.a(a[11:8]), .b(b[11:8]), .cin(carry[1]), .sum(y[11:8]), .cout(carry[2]));
    cla_4bit adder3 (.a(a[15:12]), .b(b[15:12]), .cin(carry[2]), .sum(y[15:12]), .cout(carry[3]));
    
    // Final carry out
    assign Co = carry[3];
endmodule