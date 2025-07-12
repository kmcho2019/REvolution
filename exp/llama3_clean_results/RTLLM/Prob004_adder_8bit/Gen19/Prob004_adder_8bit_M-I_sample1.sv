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

module adder_4bit(
    input   [3:0] a,
    input   [3:0] b,
    input       cin,
    output  [3:0] sum,
    output      cout
);
    
    wire c1, c2, c3;
    
    adder_1bit u0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c1));
    adder_1bit u1 (.a(a[1]), .b(b[1]), .cin(c1), .sum(sum[1]), .cout(c2));
    adder_1bit u2 (.a(a[2]), .b(b[2]), .cin(c2), .sum(sum[2]), .cout(c3));
    adder_1bit u3 (.a(a[3]), .b(b[3]), .cin(c3), .sum(sum[3]), .cout(cout));
    
endmodule

module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);
    
    wire c4, c8;
    
    adder_4bit u0 (.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum[3:0]), .cout(c4));
    adder_4bit u1 (.a(a[7:4]), .b(b[7:4]), .cin(c4), .sum(sum[7:4]), .cout(c8));
    
    assign cout = c8;
    
endmodule