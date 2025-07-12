// Module to count the number of ones in an 8-bit segment
module SegmentCounter(
    input [7:0] in,
    output [7:0] out
);
    assign out = $countones(in);
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

    // First stage of the adder tree: 32:16 reduction
    wire [7:0] stage1_sum [15:0];
    for (genvar i = 0; i < 16; i++) begin
        assign stage1_sum[i] = segment_count[i*2] + segment_count[i*2+1];
    end

    // Second stage of the adder tree: 16:8 reduction
    wire [7:0] stage2_sum [7:0];
    for (genvar i = 0; i < 8; i++) begin
        assign stage2_sum[i] = stage1_sum[i*2] + stage1_sum[i*2+1];
    end

    // Third stage of the adder tree: 8:4 reduction
    wire [7:0] stage3_sum [3:0];
    for (genvar i = 0; i < 4; i++) begin
        assign stage3_sum[i] = stage2_sum[i*2] + stage2_sum[i*2+1];
    end

    // Fourth stage of the adder tree: 4:2 reduction
    wire [7:0] stage4_sum [1:0];
    for (genvar i = 0; i < 2; i++) begin
        assign stage4_sum[i] = stage3_sum[i*2] + stage3_sum[i*2+1];
    end

    // Fifth stage of the adder tree: 2:1 reduction
    wire [7:0] final_sum;
    assign final_sum = stage4_sum[0] + stage4_sum[1];

    // Assign the output
    assign out = final_sum;

endmodule