module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

wire [3:0] sum1, sum2;
wire c1, c2, c3;

// 4-bit adder for lower bits
adder_4bit a4b0(a[3:0], b[3:0], cin, sum1, c1);

// 4-bit adder for upper bits
adder_4bit a4b1(a[7:4], b[7:4], 1'b0, sum2, c2);

// 2-bit adder for final result
adder_2bit a2b(sum1[3:2], sum2[3:2], c1, sum[7:6], c3);

// Assign lower bits of sum
assign sum[3:0] = sum1[3:0];

// Assign middle bits of sum
assign sum[5:4] = sum2[1:0];

// Final carry-out
assign cout = c2 | c3;

// Final sum bits
assign sum[6] = sum2[2];

// 2-bit adder for middle bits
adder_2bit a2b1(sum1[1:0], sum2[1:0], 1'b0, sum[1:0], );

endmodule

module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);

wire c1, c2, c3;

// Bit 0
full_adder fa0(a[0], b[0], cin, sum[0], c1);

// Bit 1
full_adder fa1(a[1], b[1], c1, sum[1], c2);

// Bit 2
full_adder fa2(a[2], b[2], c2, sum[2], c3);

// Bit 3
full_adder fa3(a[3], b[3], c3, sum[3], cout);

endmodule

module adder_2bit(
    input [1:0] a,
    input [1:0] b,
    input cin,
    output [1:0] sum,
    output cout
);

wire c1;

// Bit 0
full_adder fa0(a[0], b[0], cin, sum[0], c1);

// Bit 1
full_adder fa1(a[1], b[1], c1, sum[1], cout);

endmodule

module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule