module half_adder(
    input   a,
    input   b,
    output  sum,
    output  cout
);
    
    assign sum = a ^ b;
    assign cout = a & b;
    
endmodule

module full_adder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);
    
    wire p, g;
    
    assign p = a ^ b;
    assign g = a & b;
    assign sum = p ^ cin;
    assign cout = g | (p & cin);
    
endmodule

module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);
    
    wire c0, c1, c2, c3, c4, c5, c6;
    wire p0, p1, p2, p3, p4, p5, p6, p7;
    wire g0, g1, g2, g3, g4, g5, g6, g7;
    
    half_adder u0 (.a(a[0]), .b(b[0]), .sum(p0), .cout(g0));
    full_adder u1 (.a(a[1]), .b(b[1]), .cin(g0), .sum(p1), .cout(g1));
    full_adder u2 (.a(a[2]), .b(b[2]), .cin(g1), .sum(p2), .cout(g2));
    full_adder u3 (.a(a[3]), .b(b[3]), .cin(g2), .sum(p3), .cout(g3));
    full_adder u4 (.a(a[4]), .b(b[4]), .cin(g3), .sum(p4), .cout(g4));
    full_adder u5 (.a(a[5]), .b(b[5]), .cin(g4), .sum(p5), .cout(g5));
    full_adder u6 (.a(a[6]), .b(b[6]), .cin(g5), .sum(p6), .cout(g6));
    full_adder u7 (.a(a[7]), .b(b[7]), .cin(g6), .sum(p7), .cout(g7));
    
    assign sum[0] = p0;
    assign sum[1] = p1;
    assign sum[2] = p2;
    assign sum[3] = p3;
    assign sum[4] = p4;
    assign sum[5] = p5;
    assign sum[6] = p6;
    assign sum[7] = p7;
    assign cout = g7;
    
endmodule