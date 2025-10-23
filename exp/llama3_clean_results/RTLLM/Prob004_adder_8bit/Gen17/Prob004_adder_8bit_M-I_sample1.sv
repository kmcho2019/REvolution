// 2-bit adder module with improved area efficiency
module adder_2bit(
    input   [1:0] a,
    input   [1:0] b,
    input       cin,
    output  [1:0] sum,
    output      cout
);
    
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign cout = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);
    assign sum[1] = a[1] ^ b[1] ^ cout;

endmodule

// 4-bit adder module using carry-lookahead adder architecture
module adder_4bit(
    input   [3:0] a,
    input   [3:0] b,
    input       cin,
    output  [3:0] sum,
    output      cout
);
    
    wire c1, c2, c3;
    
    adder_2bit u0 (.a(a[1:0]), .b(b[1:0]), .cin(cin), .sum(sum[1:0]), .cout(c1));
    adder_2bit u1 (.a(a[3:2]), .b(b[3:2]), .cin(c1), .sum(sum[3:2]), .cout(c2));
    
    assign c3 = (a[3] & b[3]) | (a[3] & c2) | (b[3] & c2);
    assign cout = c3;

endmodule

// 8-bit adder module using carry-lookahead adder architecture
module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);
    
    wire c4, c5, c6, c7;
    
    adder_4bit u0 (.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum[3:0]), .cout(c4));
    adder_4bit u1 (.a(a[7:4]), .b(b[7:4]), .cin(c4), .sum(sum[7:4]), .cout(c5));
    
    assign cout = c5;

endmodule