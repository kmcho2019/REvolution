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

    // Calculate population count for each segment directly
    for (genvar i = 0; i < 32; i++) begin
        assign segment_count[i] = $countones(segment[i]);
    end

    // Group the segments into 8 groups of 4 segments
    wire [7:0] group_sum [7:0];

    // Calculate group sums directly
    for (genvar i = 0; i < 8; i++) begin
        assign group_sum[i] = segment_count[i*4] + segment_count[i*4+1] + segment_count[i*4+2] + segment_count[i*4+3];
    end

    // First stage of the adder tree: 8:4 reduction
    wire [7:0] stage1_sum [3:0];
    assign stage1_sum[0] = group_sum[0] + group_sum[1];
    assign stage1_sum[1] = group_sum[2] + group_sum[3];
    assign stage1_sum[2] = group_sum[4] + group_sum[5];
    assign stage1_sum[3] = group_sum[6] + group_sum[7];

    // Second stage of the adder tree: 4:2 reduction
    wire [7:0] stage2_sum [1:0];
    assign stage2_sum[0] = stage1_sum[0] + stage1_sum[1];
    assign stage2_sum[1] = stage1_sum[2] + stage1_sum[3];

    // Third stage of the adder tree: 2:1 reduction
    wire [7:0] final_sum;
    assign final_sum = stage2_sum[0] + stage2_sum[1];

    // Assign the output
    assign out = final_sum;

endmodule