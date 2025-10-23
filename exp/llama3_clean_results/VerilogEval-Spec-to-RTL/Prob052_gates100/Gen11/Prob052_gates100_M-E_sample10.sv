module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Divide the input into four 25-bit segments
    wire [24:0] seg1;
    wire [24:0] seg2;
    wire [24:0] seg3;
    wire [24:0] seg4;

    assign seg1 = in[24:0];
    assign seg2 = in[49:25];
    assign seg3 = in[74:50];
    assign seg4 = in[99:75];

    // Perform AND operation on each segment
    wire and_seg1;
    wire and_seg2;
    wire and_seg3;
    wire and_seg4;

    assign and_seg1 = &seg1;
    assign and_seg2 = &seg2;
    assign and_seg3 = &seg3;
    assign and_seg4 = &seg4;

    // Perform OR operation on each segment
    wire or_seg1;
    wire or_seg2;
    wire or_seg3;
    wire or_seg4;

    assign or_seg1 = |seg1;
    assign or_seg2 = |seg2;
    assign or_seg3 = |seg3;
    assign or_seg4 = |seg4;

    // Perform XOR operation on each segment using carry-save addition
    wire [24:0] xor_seg1;
    wire [24:0] xor_seg2;
    wire [24:0] xor_seg3;
    wire [24:0] xor_seg4;

    assign xor_seg1 = ^seg1;
    assign xor_seg2 = ^seg2;
    assign xor_seg3 = ^seg3;
    assign xor_seg4 = ^seg4;

    // Combine the results from each segment
    wire and_out_int;
    wire or_out_int;
    wire [24:0] xor_out_int;

    assign and_out_int = and_seg1 & and_seg2 & and_seg3 & and_seg4;
    assign or_out_int = or_seg1 | or_seg2 | or_seg3 | or_seg4;
    assign xor_out_int = xor_seg1 ^ xor_seg2 ^ xor_seg3 ^ xor_seg4;

    // Final output
    assign out_and = and_out_int;
    assign out_or = or_out_int;
    assign out_xor = xor_out_int[0]; // Only the least significant bit is needed

endmodule