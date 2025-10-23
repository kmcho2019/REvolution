// Module to count the number of ones in an 8-bit segment
module SegmentCounter(
    input [7:0] in,
    output [7:0] out
);
    assign out = $countones(in);
endmodule

// Module to calculate the sum of four segment counts
module GroupSum(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] out
);
    assign out = a + b + c + d;
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
    wire [7:0] segment_count [31:0];

    // Instantiate SegmentCounter for each segment
    for (genvar i = 0; i < 32; i++) begin
        SegmentCounter sc(
          .in(segment[i]),
          .out(segment_count[i])
        );
    end

    // Group the segments into 8 groups of 4 segments
    wire [7:0] group_sum [7:0];

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

    // Final population count using a 2-level adder tree
    wire [7:0] mid_sum [3:0];
    assign mid_sum[0] = group_sum[0] + group_sum[1];
    assign mid_sum[1] = group_sum[2] + group_sum[3];
    assign mid_sum[2] = group_sum[4] + group_sum[5];
    assign mid_sum[3] = group_sum[6] + group_sum[7];

    wire [7:0] final_sum [1:0];
    assign final_sum[0] = mid_sum[0] + mid_sum[1];
    assign final_sum[1] = mid_sum[2] + mid_sum[3];

    assign out = final_sum[0] + final_sum[1];

endmodule