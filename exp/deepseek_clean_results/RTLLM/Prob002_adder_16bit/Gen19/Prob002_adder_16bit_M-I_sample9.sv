module carry_lookahead_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output [3:0] carry,
    output g_out,
    output p_out
);
    wire [3:0] g = a & b;
    wire [3:0] p = a | b;
    
    assign carry[0] = g[0] | (p[0] & cin);
    assign carry[1] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign carry[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    assign carry[3] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | 
                      (p[3] & p[2] & p[1] & p[0] & cin);
    
    assign sum = a ^ b ^ {carry[2:0], cin};
    assign g_out = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign p_out = p[3] & p[2] & p[1] & p[0];
endmodule

module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire g0, p0, g1, p1;
    wire [3:0] carry_mid;
    
    carry_lookahead_4bit low (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .carry(),
        .g_out(g0),
        .p_out(p0)
    );
    
    carry_lookahead_4bit high (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(carry_mid[3]),
        .sum(sum[7:4]),
        .carry(),
        .g_out(g1),
        .p_out(p1)
    );
    
    // Block carry lookahead
    assign carry_mid[0] = g0 | (p0 & cin);
    assign carry_mid[1] = g0 | (p0 & cin);
    assign carry_mid[2] = g0 | (p0 & cin);
    assign carry_mid[3] = g0 | (p0 & cin);
    assign cout = g1 | (p1 & g0) | (p1 & p0 & cin);
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire g0, p0, g1, p1;
    wire carry_middle;
    
    adder_8bit low (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout()
    );
    
    adder_8bit high (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_middle),
        .sum(y[15:8]),
        .cout(Co)
    );
    
    // Block carry lookahead between 8-bit adders
    assign carry_middle = g0 | (p0 & Cin);
endmodule