module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Divide the adder into two 4-bit segments
wire [3:0] sum_low;
wire cout_low;
wire [3:0] sum_high;
wire cout_high;

// Implement 4-bit ripple-carry adders for each segment
adder_4bit adder_low(
    .a(a[3:0]),
    .b(b[3:0]),
    .cin(cin),
    .sum(sum_low),
    .cout(cout_low)
);

// Use carry-lookahead logic to propagate carry between segments
assign cout = cout_high;

// Implement 4-bit ripple-carry adder for the high segment
// with the carry-in from the low segment
adder_4bit adder_high(
    .a(a[7:4]),
    .b(b[7:4]),
    .cin(cout_low),
    .sum(sum_high),
    .cout(cout_high)
);

// Combine the sum of the two segments
assign sum[3:0] = sum_low;
assign sum[7:4] = sum_high;

endmodule

// 4-bit ripple-carry adder module
module adder_4bit(
    input   [3:0] a,
    input   [3:0] b,
    input       cin,
    output  [3:0] sum,
    output      cout
);

wire [3:1] c;

// Initialize carry-in
assign c[0] = cin;

// Implement ripple-carry logic
assign sum[0] = a[0] ^ b[0] ^ c[0];
assign c[1] = (a[0] & b[0]) | (a[0] & c[0]) | (b[0] & c[0]);
assign sum[1] = a[1] ^ b[1] ^ c[1];
assign c[2] = (a[1] & b[1]) | (a[1] & c[1]) | (b[1] & c[1]);
assign sum[2] = a[2] ^ b[2] ^ c[2];
assign c[3] = (a[2] & b[2]) | (a[2] & c[2]) | (b[2] & c[2]);
assign sum[3] = a[3] ^ b[3] ^ c[3];
assign cout = (a[3] & b[3]) | (a[3] & c[3]) | (b[3] & c[3]);

endmodule