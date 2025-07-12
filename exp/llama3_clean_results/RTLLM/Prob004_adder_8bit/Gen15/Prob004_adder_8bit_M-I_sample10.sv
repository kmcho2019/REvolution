module adder_1bit(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);
    
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
    
endmodule

module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);
    
    wire [7:1] c;
    
    adder_1bit u0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c[1]));
    adder_1bit u1 (.a(a[1]), .b(b[1]), .cin(c[1]), .sum(sum[1]), .cout(c[2]));
    adder_1bit u2 (.a(a[2]), .b(b[2]), .cin(c[2]), .sum(sum[2]), .cout(c[3]));
    adder_1bit u3 (.a(a[3]), .b(b[3]), .cin(c[3]), .sum(sum[3]), .cout(c[4]));
    adder_1bit u4 (.a(a[4]), .b(b[4]), .cin(c[4]), .sum(sum[4]), .cout(c[5]));
    adder_1bit u5 (.a(a[5]), .b(b[5]), .cin(c[5]), .sum(sum[5]), .cout(c[6]));
    adder_1bit u6 (.a(a[6]), .b(b[6]), .cin(c[6]), .sum(sum[6]), .cout(c[7]));
    adder_1bit u7 (.a(a[7]), .b(b[7]), .cin(c[7]), .sum(sum[7]), .cout(cout));
    
endmodule