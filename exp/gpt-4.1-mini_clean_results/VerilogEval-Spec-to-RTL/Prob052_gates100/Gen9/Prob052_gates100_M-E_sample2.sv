module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);
    localparam INPUT_WIDTH = 100;
    localparam PADDED_WIDTH = 128; // next power of two >= 100
    localparam STAGES = 7;          // log2(128)

    // Pad inputs for each logic function with neutral values:
    // AND neutral: 1, OR neutral: 0, XOR neutral: 0
    wire [PADDED_WIDTH-1:0] and_in_padded;
    wire [PADDED_WIDTH-1:0] or_in_padded;
    wire [PADDED_WIDTH-1:0] xor_in_padded;

    // Assign padded inputs
    assign and_in_padded = { {(PADDED_WIDTH-INPUT_WIDTH){1'b1}}, in }; // pad MSBs with 1
    assign or_in_padded  = { {(PADDED_WIDTH-INPUT_WIDTH){1'b0}}, in }; // pad MSBs with 0
    assign xor_in_padded = { {(PADDED_WIDTH-INPUT_WIDTH){1'b0}}, in }; // pad MSBs with 0

    // Declare arrays of wires for each stage
    // Stage 0 (bottom): input vectors
    wire [PADDED_WIDTH-1:0] and_stage [0:STAGES];
    wire [PADDED_WIDTH-1:0] or_stage  [0:STAGES];
    wire [PADDED_WIDTH-1:0] xor_stage [0:STAGES];

    // Initialize stage 0 with padded inputs
    assign and_stage[0] = and_in_padded;
    assign or_stage[0]  = or_in_padded;
    assign xor_stage[0] = xor_in_padded;

    genvar stage, idx;
    generate
        for (stage = 1; stage <= STAGES; stage = stage + 1) begin : reduction_stages
            localparam WIDTH = PADDED_WIDTH >> stage; // half width each stage

            for (idx = 0; idx < WIDTH; idx = idx + 1) begin : pairwise_ops
                assign and_stage[stage][idx] = and_stage[stage-1][2*idx] & and_stage[stage-1][2*idx + 1];
                assign or_stage[stage][idx]  = or_stage[stage-1][2*idx]  | or_stage[stage-1][2*idx + 1];
                assign xor_stage[stage][idx] = xor_stage[stage-1][2*idx] ^ xor_stage[stage-1][2*idx + 1];
            end
        end
    endgenerate

    // The final output is the single bit at the last stage, index 0
    assign out_and = and_stage[STAGES][0];
    assign out_or  = or_stage[STAGES][0];
    assign out_xor = xor_stage[STAGES][0];

endmodule