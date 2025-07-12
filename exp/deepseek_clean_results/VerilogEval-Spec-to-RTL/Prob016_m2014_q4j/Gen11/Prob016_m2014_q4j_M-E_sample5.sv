module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output p,
    output g
);
    assign sum = a ^ b ^ cin;
    assign p = a ^ b;       // Propagate
    assign g = a & b;       // Generate
endmodule

module CarrySkipBlock(
    input [1:0] x,
    input [1:0] y,
    input cin,
    output [1:0] sum,
    output p_group,
    output g_group,
    output cout
);
    wire [1:0] p, g;
    wire carry_mid;
    
    // First bit in block
    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(cin),
        .sum(sum[0]),
        .p(p[0]),
        .g(g[0])
    );
    
    // Second bit in block
    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(carry_mid),
        .sum(sum[1]),
        .p(p[1]),
        .g(g[1])
    );
    
    // Block carry logic
    assign carry_mid = g[0] | (p[0] & cin);
    assign p_group = p[0] & p[1];  // Block propagate
    assign g_group = g[1] | (p[1] & g[0]);  // Block generate
    
    // Carry skip mux
    assign cout = p_group ? cin : g_group;
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire p_group0, g_group0;
    wire p_group1, g_group1;
    wire carry1;
    
    // First 2-bit block (bits 1:0)
    CarrySkipBlock block0(
        .x(x[1:0]),
        .y(y[1:0]),
        .cin(1'b0),
        .sum(sum[1:0]),
        .p_group(p_group0),
        .g_group(g_group0),
        .cout(carry1)
    );
    
    // Second 2-bit block (bits 3:2)
    CarrySkipBlock block1(
        .x(x[3:2]),
        .y(y[3:2]),
        .cin(carry1),
        .sum(sum[3:2]),
        .p_group(p_group1),
        .g_group(g_group1),
        .cout(sum[4])
    );
endmodule