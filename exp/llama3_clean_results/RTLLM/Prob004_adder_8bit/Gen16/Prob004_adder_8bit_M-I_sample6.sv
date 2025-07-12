// Optimized 2-bit adder using full adder logic directly
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

// Optimized 4-bit adder using two 2-bit adders
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

// Optimized 8-bit adder using two 4-bit adders
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