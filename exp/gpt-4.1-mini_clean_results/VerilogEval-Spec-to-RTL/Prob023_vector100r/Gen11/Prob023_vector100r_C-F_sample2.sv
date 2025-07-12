module BitRevN #(parameter N = 10) (
    input  [N-1:0] in,
    output [N-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : bit_reverse
            assign out[i] = in[N - 1 - i];
        end
    endgenerate
endmodule

module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    // Number of segments and segment width
    localparam NUM_SEG = 10;
    localparam SEG_W = 10;

    // Segment input and output wires
    wire [SEG_W-1:0] segments_in [NUM_SEG-1:0];
    wire [SEG_W-1:0] segments_out [NUM_SEG-1:0];

    genvar i;
    generate
        // Extract 10-bit segments
        for (i = 0; i < NUM_SEG; i = i + 1) begin : segment_extract
            assign segments_in[i] = in[i*SEG_W +: SEG_W];
        end

        // Reverse each 10-bit segment
        for (i = 0; i < NUM_SEG; i = i + 1) begin : segment_reverse
            BitRevN #(SEG_W) bitrev_inst (
                .in(segments_in[i]),
                .out(segments_out[i])
            );
        end

        // Concatenate reversed segments in reverse order to form output
        for (i = 0; i < NUM_SEG; i = i + 1) begin : segment_concat
            assign out[i*SEG_W +: SEG_W] = segments_out[NUM_SEG - 1 - i];
        end
    endgenerate

endmodule