// Define the module for a 4-bit segment adder
module segment_adder(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] sum,
    output Co
);

// Internal signals for XOR and AND operations
wire [3:0] xor_result;
wire [3:0] and_result;

// Perform bitwise XOR operation
assign xor_result = a ^ b;

// Perform bitwise AND operation
assign and_result = a & b;

// Generate the sum bits
assign sum = xor_result ^ Cin;

// Generate the carry-out signal
assign Co = (and_result[0] & Cin) | (and_result[1] & (xor_result[0] ^ Cin)) | (and_result[2] & (xor_result[1] ^ (xor_result[0] ^ Cin))) | (and_result[3] & (xor_result[2] ^ (xor_result[1] ^ (xor_result[0] ^ Cin))));

endmodule

// Define the module for the 16-bit full adder
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

// Internal signals for segment adders
wire [3:0] seg1_sum;
wire [3:0] seg2_sum;
wire [3:0] seg3_sum;
wire [3:0] seg4_sum;
wire seg1_Co;
wire seg2_Co;
wire seg3_Co;
wire seg4_Co;

// Instantiate the segment adders
segment_adder seg1(
    .a(a[3:0]),
    .b(b[3:0]),
    .Cin(Cin),
    .sum(seg1_sum),
    .Co(seg1_Co)
);

segment_adder seg2(
    .a(a[7:4]),
    .b(b[7:4]),
    .Cin(seg1_Co),
    .sum(seg2_sum),
    .Co(seg2_Co)
);

segment_adder seg3(
    .a(a[11:8]),
    .b(b[11:8]),
    .Cin(seg2_Co),
    .sum(seg3_sum),
    .Co(seg3_Co)
);

segment_adder seg4(
    .a(a[15:12]),
    .b(b[15:12]),
    .Cin(seg3_Co),
    .sum(seg4_sum),
    .Co(seg4_Co)
);

// Combine the sum bits from each segment
assign y[3:0] = seg1_sum;
assign y[7:4] = seg2_sum;
assign y[11:8] = seg3_sum;
assign y[15:12] = seg4_sum;

// Assign the carry-out signal
assign Co = seg4_Co;

endmodule