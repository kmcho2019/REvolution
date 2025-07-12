module SegmentOperation(
    input [24:0] in,
    output and_out,
    output or_out,
    output xor_out
);

    // Initialize variables to store the result of AND, OR, and XOR operations
    reg and_result = 1'b1;
    reg or_result = 1'b0;
    reg xor_result = 1'b0;

    // Perform AND operation
    integer i;
    always @(in) begin
        and_result = 1'b1;
        or_result = 1'b0;
        xor_result = 1'b0;
        for (i = 0; i < 25; i = i + 1) begin
            and_result = and_result & in[i];
            or_result = or_result | in[i];
            xor_result = xor_result ^ in[i];
        end
    end

    // Assign results to output ports
    assign and_out = and_result;
    assign or_out = or_result;
    assign xor_out = xor_result;

endmodule

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

    // Perform operations on each segment
    wire and_seg1, or_seg1, xor_seg1;
    wire and_seg2, or_seg2, xor_seg2;
    wire and_seg3, or_seg3, xor_seg3;
    wire and_seg4, or_seg4, xor_seg4;

    SegmentOperation seg1_op(seg1, and_seg1, or_seg1, xor_seg1);
    SegmentOperation seg2_op(seg2, and_seg2, or_seg2, xor_seg2);
    SegmentOperation seg3_op(seg3, and_seg3, or_seg3, xor_seg3);
    SegmentOperation seg4_op(seg4, and_seg4, or_seg4, xor_seg4);

    // Combine the results from each segment
    assign out_and = and_seg1 & and_seg2 & and_seg3 & and_seg4;
    assign out_or = or_seg1 | or_seg2 | or_seg3 | or_seg4;
    assign out_xor = xor_seg1 ^ xor_seg2 ^ xor_seg3 ^ xor_seg4;

endmodule