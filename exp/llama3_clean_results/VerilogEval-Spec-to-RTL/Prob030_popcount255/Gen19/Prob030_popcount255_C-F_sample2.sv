// Module to count the number of ones in an 8-bit segment
module SegmentCounter(
    input [7:0] in,
    output [4:0] out
);
    assign out = $countones(in);
endmodule

// Module to calculate the sum of four segment counts
module GroupSum(
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    output [6:0] out
);
    assign out = a + b + c + d;
endmodule

// Module for a 2:1 adder
module Adder2to1(
    input [7:0] a,
    input [7:0] b,
    output [7:0] out
);
    assign out = a + b;
endmodule

// Top-level module for population count
module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Divide the input into 32 segments of 8 bits
    wire [7:0] segment [31:0];

    // Assign the segments
    genvar i;
    for (i = 0; i < 32; i++) begin
        if (i == 31) begin
            assign segment[i] = {1'b0, in[254:248]};
        end else begin
            assign segment[i] = in[(i*8)+7:i*8];
        end
    end

    // Population counts for each segment
    wire [4:0] segment_count [31:0];

    // Instantiate SegmentCounter for each segment
    for (genvar i = 0; i < 32; i++) begin
        SegmentCounter sc(
          .in(segment[i]),
          .out(segment_count[i])
        );
    end

    // Group the segments into 8 groups of 4 segments
    wire [6:0] group_sum [7:0];

    // Instantiate GroupSum for each group
    for (genvar i = 0; i < 8; i++) begin
        GroupSum gs(
          .a(segment_count[i*4]),
          .b(segment_count[i*4+1]),
          .c(segment_count[i*4+2]),
          .d(segment_count[i*4+3]),
          .out(group_sum[i])
        );
    end

    // First stage of the adder tree: 8:4 reduction
    wire [7:0] stage1_sum [3:0];
    Adder2to1 add1 (.a(group_sum[0]),.b(group_sum[1]),.out(stage1_sum[0]));
    Adder2to1 add2 (.a(group_sum[2]),.b(group_sum[3]),.out(stage1_sum[1]));
    Adder2to1 add3 (.a(group_sum[4]),.b(group_sum[5]),.out(stage1_sum[2]));
    Adder2to1 add4 (.a(group_sum[6]),.b(group_sum[7]),.out(stage1_sum[3]));

    // Second stage of the adder tree: 4:2 reduction
    wire [7:0] stage2_sum [1:0];
    Adder2to1 add5 (.a(stage1_sum[0]),.b(stage1_sum[1]),.out(stage2_sum[0]));
    Adder2to1 add6 (.a(stage1_sum[2]),.b(stage1_sum[3]),.out(stage2_sum[1]));

    // Third stage of the adder tree: 2:1 reduction
    wire [7:0] final_sum;
    Adder2to1 add7 (.a(stage2_sum[0]),.b(stage2_sum[1]),.out(final_sum));

    // Assign the output
    assign out = final_sum;

endmodule