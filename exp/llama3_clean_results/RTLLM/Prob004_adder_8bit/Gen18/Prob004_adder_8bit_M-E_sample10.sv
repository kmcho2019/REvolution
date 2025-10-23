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
    
    wire sum1, cout1, sum2, cout2;
    
    half_adder u0 (.a(a), .b(b), .sum(sum1), .cout(cout1));
    half_adder u1 (.a(sum1), .b(cin), .sum(sum), .cout(cout2));
    assign cout = cout1 | cout2;
    
endmodule

module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);
    
    wire c1, c2, c3, c4, c5, c6, c7;
    
    full_adder u0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c1));
    full_adder u1 (.a(a[1]), .b(b[1]), .cin(c1), .sum(sum[1]), .cout(c2));
    full_adder u2 (.a(a[2]), .b(b[2]), .cin(c2), .sum(sum[2]), .cout(c3));
    full_adder u3 (.a(a[3]), .b(b[3]), .cin(c3), .sum(sum[3]), .cout(c4));
    full_adder u4 (.a(a[4]), .b(b[4]), .cin(c4), .sum(sum[4]), .cout(c5));
    full_adder u5 (.a(a[5]), .b(b[5]), .cin(c5), .sum(sum[5]), .cout(c6));
    full_adder u6 (.a(a[6]), .b(b[6]), .cin(c6), .sum(sum[6]), .cout(c7));
    full_adder u7 (.a(a[7]), .b(b[7]), .cin(c7), .sum(sum[7]), .cout(cout));
    
endmodule