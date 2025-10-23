module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Split the 8-bit operands into two 4-bit halves
wire [3:0] a_lo = a[3:0];
wire [3:0] a_hi = a[7:4];
wire [3:0] b_lo = b[3:0];
wire [3:0] b_hi = b[7:4];

// Perform the addition on each 4-bit half
wire [3:0] sum_lo;
wire      cout_lo;
wire [3:0] sum_hi;
wire      cout_hi;

// 4-bit adder for the low half
adder_4bit adder_lo(
    .a(a_lo),
    .b(b_lo),
    .cin(cin),
    .sum(sum_lo),
    .cout(cout_lo)
);

// 4-bit adder for the high half
adder_4bit adder_hi(
    .a(a_hi),
    .b(b_hi),
    .cin(cout_lo),
    .sum(sum_hi),
    .cout(cout_hi)
);

// Combine the results of the two 4-bit additions
assign sum[3:0] = sum_lo;
assign sum[7:4] = sum_hi;

// Compute the final carry-out signal using the carry save technique
assign cout = cout_hi;

endmodule

// 4-bit adder module
module adder_4bit(
    input   [3:0] a,
    input   [3:0] b,
    input       cin,
    output  [3:0] sum,
    output      cout
);

// Perform the addition on each bit
wire [3:0] sum_bits;
wire [3:0] carry_bits;

// Bit-level adders
assign sum_bits[0] = a[0] ^ b[0] ^ cin;
assign carry_bits[0] = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);
assign sum_bits[1] = a[1] ^ b[1] ^ carry_bits[0];
assign carry_bits[1] = (a[1] & b[1]) | (a[1] & carry_bits[0]) | (b[1] & carry_bits[0]);
assign sum_bits[2] = a[2] ^ b[2] ^ carry_bits[1];
assign carry_bits[2] = (a[2] & b[2]) | (a[2] & carry_bits[1]) | (b[2] & carry_bits[1]);
assign sum_bits[3] = a[3] ^ b[3] ^ carry_bits[2];
assign carry_bits[3] = (a[3] & b[3]) | (a[3] & carry_bits[2]) | (b[3] & carry_bits[2]);

// Combine the results of the bit-level additions
assign sum = sum_bits;
assign cout = carry_bits[3];

endmodule