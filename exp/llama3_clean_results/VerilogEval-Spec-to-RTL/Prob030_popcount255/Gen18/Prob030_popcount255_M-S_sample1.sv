module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Divide the input into 32 segments of 8 bits
    wire [7:0] segment_count [31:0];

    // Population counts for each segment
    genvar i;
    for (i = 0; i < 32; i++) begin
        if (i == 31) begin
            assign segment_count[i] = $countones({1'b0, in[254:248]});
        end else begin
            assign segment_count[i] = $countones(in[(i*8)+7:i*8]);
        end
    end

    // Final population count using a 5-level adder tree
    wire [7:0] level1_sum [15:0];
    for (i = 0; i < 16; i++) begin
        assign level1_sum[i] = segment_count[i*2] + segment_count[i*2+1];
    end

    wire [7:0] level2_sum [7:0];
    for (i = 0; i < 8; i++) begin
        assign level2_sum[i] = level1_sum[i*2] + level1_sum[i*2+1];
    end

    wire [7:0] level3_sum [3:0];
    for (i = 0; i < 4; i++) begin
        assign level3_sum[i] = level2_sum[i*2] + level2_sum[i*2+1];
    end

    wire [7:0] level4_sum [1:0];
    for (i = 0; i < 2; i++) begin
        assign level4_sum[i] = level3_sum[i*2] + level3_sum[i*2+1];
    end

    assign out = level4_sum[0] + level4_sum[1];

endmodule