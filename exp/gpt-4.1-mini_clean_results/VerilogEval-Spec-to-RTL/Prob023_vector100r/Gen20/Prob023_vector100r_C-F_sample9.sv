module BitRevN #(parameter N = 10) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : bit_reversal
            assign out[i] = in[N-1 - i];
        end
    endgenerate
endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    localparam SEG_WIDTH = 10;
    localparam NUM_SEGS = 100 / SEG_WIDTH;  // 10 segments

    wire [SEG_WIDTH-1:0] seg_in [0:NUM_SEGS-1];
    wire [SEG_WIDTH-1:0] seg_out [0:NUM_SEGS-1];

    genvar i;
    // Split input into segments
    generate
        for (i = 0; i < NUM_SEGS; i = i + 1) begin : input_segmentation
            assign seg_in[i] = in[i*SEG_WIDTH +: SEG_WIDTH];
        end
    endgenerate

    // Reverse each segment using BitRevN
    generate
        for (i = 0; i < NUM_SEGS; i = i + 1) begin : bitrev_segments
            BitRevN #(SEG_WIDTH) bitrev_inst (
                .in(seg_in[i]),
                .out(seg_out[i])
            );
        end
    endgenerate

    // Concatenate reversed segments in reversed order to form output
    generate
        for (i = 0; i < NUM_SEGS; i = i + 1) begin : output_concat
            assign out[i*SEG_WIDTH +: SEG_WIDTH] = seg_out[NUM_SEGS-1 - i];
        end
    endgenerate
endmodule