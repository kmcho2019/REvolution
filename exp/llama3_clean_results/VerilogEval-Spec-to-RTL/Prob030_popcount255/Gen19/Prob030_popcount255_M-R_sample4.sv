module TopModule(
    input [254:0] in,
    output [7:0] out
);

    wire [7:0] segment_count [31:0];
    genvar i;

    // Count ones in each 8-bit segment of the input
    for (i = 0; i < 32; i++) begin
        if (i == 31) begin
            assign segment_count[i] = $countones({1'b0, in[254:248]});
        end else begin
            assign segment_count[i] = $countones(in[(i*8)+7:i*8]);
        end
    end

    // Group the segment counts and sum them in a hierarchical manner
    wire [7:0] group_sum [7:0];
    for (i = 0; i < 8; i++) begin
        assign group_sum[i] = segment_count[i*4] + segment_count[i*4+1] + segment_count[i*4+2] + segment_count[i*4+3];
    end

    // Final population count using a simplified hierarchical adder tree
    wire [7:0] mid_sum [3:0];
    assign mid_sum[0] = group_sum[0] + group_sum[1];
    assign mid_sum[1] = group_sum[2] + group_sum[3];
    assign mid_sum[2] = group_sum[4] + group_sum[5];
    assign mid_sum[3] = group_sum[6] + group_sum[7];

    wire [7:0] final_sum;
    assign final_sum = mid_sum[0] + mid_sum[1] + mid_sum[2] + mid_sum[3];

    assign out = final_sum;

endmodule