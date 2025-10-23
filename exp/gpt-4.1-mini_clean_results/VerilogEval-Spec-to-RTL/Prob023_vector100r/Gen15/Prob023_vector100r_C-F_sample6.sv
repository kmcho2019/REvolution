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
    // Parameter for segment width and number of segments
    localparam SEG_WIDTH = 10;
    localparam NUM_SEGS = 100 / SEG_WIDTH;

    // Wires for segment inputs and outputs
    wire [SEG_WIDTH-1:0] seg_in [0:NUM_SEGS-1];
    wire [SEG_WIDTH-1:0] seg_out [0:NUM_SEGS-1];

    genvar i;
    generate
        // Extract segments from input
        for (i = 0; i < NUM_SEGS; i = i + 1) begin : segment_extract
            assign seg_in[i] = in[i*SEG_WIDTH +: SEG_WIDTH];
        end

        // Reverse each segment
        for (i = 0; i < NUM_SEGS; i = i + 1) begin : segment_reverse
            BitRevN #(SEG_WIDTH) bitrev_inst (
                .in(seg_in[i]),
                .out(seg_out[i])
            );
        end

        // Concatenate reversed segments in reverse order for final output
        for (i = 0; i < NUM_SEGS; i = i + 1) begin : segment_concat
            assign out[i*SEG_WIDTH +: SEG_WIDTH] = seg_out[NUM_SEGS - 1 - i];
        end
    endgenerate
endmodule