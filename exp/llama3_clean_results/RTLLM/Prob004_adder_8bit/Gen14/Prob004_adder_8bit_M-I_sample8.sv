module full_adder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);
    
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
    
endmodule

module adder_2bit(
    input   [1:0] a,
    input   [1:0] b,
    input       cin,
    output  [1:0] sum,
    output      cout
);
    
    wire c0;
    
    full_adder u0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c0));
    full_adder u1 (.a(a[1]), .b(b[1]), .cin(c0), .sum(sum[1]), .cout(cout));
    
endmodule

module adder_4bit(
    input   [3:0] a,
    input   [3:0] b,
    input       cin,
    output  [3:0] sum,
    output      cout
);
    
    wire c1;
    
    adder_2bit u0 (.a(a[1:0]), .b(b[1:0]), .cin(cin), .sum(sum[1:0]), .cout(c1));
    adder_2bit u1 (.a(a[3:2]), .b(b[3:2]), .cin(c1), .sum(sum[3:2]), .cout(cout));
    
endmodule

module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);
    
    wire c1;
    
    adder_4bit u0 (.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum[3:0]), .cout(c1));
    adder_4bit u1 (.a(a[7:4]), .b(b[7:4]), .cin(c1), .sum(sum[7:4]), .cout(cout));
    
endmodule