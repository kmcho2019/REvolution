module half_adder(
    input   a,
    input   b,
    output  sum,
    output  cout
);
    
    assign sum = a ^ b;
    assign cout = a & b;
    
endmodule

module carry_generator(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] cout
);
    
    assign cout[0] = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);
    assign cout[1] = (a[1] & b[1]) | (a[1] & cout[0]) | (b[1] & cout[0]);
    assign cout[2] = (a[2] & b[2]) | (a[2] & cout[1]) | (b[2] & cout[1]);
    assign cout[3] = (a[3] & b[3]) | (a[3] & cout[2]) | (b[3] & cout[2]);
    assign cout[4] = (a[4] & b[4]) | (a[4] & cout[3]) | (b[4] & cout[3]);
    assign cout[5] = (a[5] & b[5]) | (a[5] & cout[4]) | (b[5] & cout[4]);
    assign cout[6] = (a[6] & b[6]) | (a[6] & cout[5]) | (b[6] & cout[5]);
    assign cout[7] = (a[7] & b[7]) | (a[7] & cout[6]) | (b[7] & cout[6]);
    
endmodule

module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);
    
    wire [7:0] c;
    wire [7:0] s;
    
    carry_generator u0 (.a(a), .b(b), .cin(cin), .cout(c));
    half_adder u1 (.a(a[0]), .b(b[0]), .cin(cin), .sum(s[0]), .cout());
    half_adder u2 (.a(a[1]), .b(b[1]), .cin(c[0]), .sum(s[1]), .cout());
    half_adder u3 (.a(a[2]), .b(b[2]), .cin(c[1]), .sum(s[2]), .cout());
    half_adder u4 (.a(a[3]), .b(b[3]), .cin(c[2]), .sum(s[3]), .cout());
    half_adder u5 (.a(a[4]), .b(b[4]), .cin(c[3]), .sum(s[4]), .cout());
    half_adder u6 (.a(a[5]), .b(b[5]), .cin(c[4]), .sum(s[5]), .cout());
    half_adder u7 (.a(a[6]), .b(b[6]), .cin(c[5]), .sum(s[6]), .cout());
    half_adder u8 (.a(a[7]), .b(b[7]), .cin(c[6]), .sum(s[7]), .cout());
    
    assign sum = s;
    assign cout = c[7];
    
endmodule