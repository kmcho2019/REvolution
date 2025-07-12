module GeneratePropagate(
    input   a,
    input   b,
    output  g,
    output  p
);
    assign g = a & b;
    assign p = a | b;
endmodule

module SumBlock(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module CarryLookaheadAdder(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);
    wire [3:0] g, p;
    wire [3:0] c;
    
    GeneratePropagate gp0(
       .a(x[0]),
       .b(y[0]),
       .g(g[0]),
       .p(p[0])
    );
    
    GeneratePropagate gp1(
       .a(x[1]),
       .b(y[1]),
       .g(g[1]),
       .p(p[1])
    );
    
    GeneratePropagate gp2(
       .a(x[2]),
       .b(y[2]),
       .g(g[2]),
       .p(p[2])
    );
    
    GeneratePropagate gp3(
       .a(x[3]),
       .b(y[3]),
       .g(g[3]),
       .p(p[3])
    );
    
    assign c[0] = g[0];
    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & c[1]);
    assign c[3] = g[3] | (p[3] & c[2]);
    
    SumBlock sb0(
       .a(x[0]),
       .b(y[0]),
       .cin(1'b0),
       .sum(sum[0]),
       .cout()
    );
    
    SumBlock sb1(
       .a(x[1]),
       .b(y[1]),
       .cin(c[0]),
       .sum(sum[1]),
       .cout()
    );
    
    SumBlock sb2(
       .a(x[2]),
       .b(y[2]),
       .cin(c[1]),
       .sum(sum[2]),
       .cout()
    );
    
    SumBlock sb3(
       .a(x[3]),
       .b(y[3]),
       .cin(c[2]),
       .sum(sum[3]),
       .cout(sum[4])
    );
endmodule