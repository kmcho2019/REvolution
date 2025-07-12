module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

// Divide the 100-bit input into 4 segments of 25 bits each
wire [24:0] seg1 = in[24:0];
wire [24:0] seg2 = in[49:25];
wire [24:0] seg3 = in[74:50];
wire [24:0] seg4 = in[99:75];

// Perform operations on each segment
wire seg1_and = &seg1;
wire seg2_and = &seg2;
wire seg3_and = &seg3;
wire seg4_and = &seg4;

wire seg1_or = |seg1;
wire seg2_or = |seg2;
wire seg3_or = |seg3;
wire seg4_or = |seg4;

wire seg1_xor = ^seg1;
wire seg2_xor = ^seg2;
wire seg3_xor = ^seg3;
wire seg4_xor = ^seg4;

// Combine the results of the segments for AND and OR operations
assign out_and = seg1_and & seg2_and & seg3_and & seg4_and;
assign out_or  = seg1_or | seg2_or | seg3_or | seg4_or;

// Combine the results of the segments for XOR operation sequentially
assign out_xor = seg1_xor ^ seg2_xor ^ seg3_xor ^ seg4_xor;

endmodule