module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// 2-bit adder module
module adder_2bit(
    input   [1:0] a,
    input   [1:0] b,
    input       cin,
    output  [1:0] sum,
    output      cout
);
    wire c1, c2;
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign c1 = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);
    assign sum[1] = a[1] ^ b[1] ^ c1;
    assign c2 = (a[1] & b[1]) | (a[1] & c1) | (b[1] & c1);
    assign cout = c2;
endmodule

// 4-bit adder module
module adder_4bit(
    input   [3:0] a,
    input   [3:0] b,
    input       cin,
    output  [3:0] sum,
    output      cout
);
    wire [1:0] sum1, sum2;
    wire c1, c2;
    adder_2bit u1(.a(a[1:0]), .b(b[1:0]), .cin(cin), .sum(sum1), .cout(c1));
    adder_2bit u2(.a(a[3:2]), .b(b[3:2]), .cin(c1), .sum(sum2), .cout(c2));
    assign sum[1:0] = sum1;
    assign sum[3:2] = sum2;
    assign cout = c2;
endmodule

// 8-bit adder
wire [3:0] sum1, sum2;
wire c1;
adder_4bit u1(.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum1), .cout(c1));
adder_4bit u2(.a(a[7:4]), .b(b[7:4]), .cin(c1), .sum(sum2), .cout(cout));
assign sum[3:0] = sum1;
assign sum[7:4] = sum2;

endmodule