module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First stage: count 1s in each 8-bit segment (32 segments)
    wire [3:0] segment_counts [0:31];
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : segment_counters
            assign segment_counts[i] = 
                in[i*8+0] + in[i*8+1] + in[i*8+2] + in[i*8+3] +
                in[i*8+4] + in[i*8+5] + in[i*8+6] + in[i*8+7];
        end
        // Last segment has only 7 bits (255 = 31*8 + 7)
        assign segment_counts[31] = 
            in[248] + in[249] + in[250] + in[251] +
            in[252] + in[253] + in[254];
    endgenerate

    // Parallel prefix adder network (log2(32) = 5 stages)
    wire [7:0] pp_stage [0:4][0:31];
    
    // Stage 0: Initial values (zero-extend 4-bit counts to 8-bit)
    generate
        for (i = 0; i < 32; i = i + 1) begin : init_stage
            assign pp_stage[0][i] = {4'b0, segment_counts[i]};
        end
    endgenerate
    
    // Prefix stages 1-5
    generate
        for (genvar stage = 1; stage <= 5; stage = stage + 1) begin : prefix_stages
            for (i = 0; i < 32; i = i + 1) begin : prefix_ops
                if (i < (1 << (stage-1))) begin
                    // Pass through values that can't be combined yet
                    assign pp_stage[stage][i] = pp_stage[stage-1][i];
                end else begin
                    // Combine with value 2^(stage-1) positions back
                    assign pp_stage[stage][i] = 
                        pp_stage[stage-1][i] + pp_stage[stage-1][i - (1 << (stage-1))];
                end
            end
        end
    endgenerate

    // Final sum is the last element of the final stage plus the last segment
    assign out = pp_stage[5][31];

endmodule