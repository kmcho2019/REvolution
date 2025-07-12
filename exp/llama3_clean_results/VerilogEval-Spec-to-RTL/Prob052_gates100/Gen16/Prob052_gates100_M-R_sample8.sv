module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Divide the input into four 25-bit segments
    wire [24:0] seg1 = in[24:0];
    wire [24:0] seg2 = in[49:25];
    wire [24:0] seg3 = in[74:50];
    wire [24:0] seg4 = in[99:75];

    // Perform operations on each segment
    assign out_and = (&seg1) & (&seg2) & (&seg3) & (&seg4);
    assign out_or = (|seg1) | (|seg2) | (|seg3) | (|seg4);
    assign out_xor = (^seg1) ^ (^seg2) ^ (^seg3) ^ (^seg4);

endmodule