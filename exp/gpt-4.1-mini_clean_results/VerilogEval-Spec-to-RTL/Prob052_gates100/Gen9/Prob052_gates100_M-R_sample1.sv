module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Parameters
    localparam WIDTH = 100;

    // Calculate the number of reduction stages needed: ceil(log2(WIDTH))
    // For 100 inputs, stages = 7 (since 2^7=128 >= 100)
    localparam STAGES = 7;

    // Internal signals for each stage for each operation
    // Each stage reduces the vector length approximately by half (ceil div)
    // We store signals in arrays indexed by stage
    wire [WIDTH-1:0] and_stage [0:STAGES];
    wire [WIDTH-1:0] or_stage  [0:STAGES];
    wire [WIDTH-1:0] xor_stage [0:STAGES];

    // Initialize stage 0 with input bits, fill extra bits with identity elements
    // AND identity: 1 (does not affect AND)
    // OR identity: 0 (does not affect OR)
    // XOR identity: 0 (does not affect XOR)
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : init_stage0
            assign and_stage[0][i] = in[i];
            assign or_stage[0][i]  = in[i];
            assign xor_stage[0][i] = in[i];
        end
        // For bits beyond WIDTH up to 2^STAGES (max 128), assign identity values
        for (i = WIDTH; i < (1 << STAGES); i = i + 1) begin : init_stage0_extra
            assign and_stage[0][i] = 1'b1;
            assign or_stage[0][i]  = 1'b0;
            assign xor_stage[0][i] = 1'b0;
        end
    endgenerate

    // Reduction stages
    // Each next stage reduces size by half, combining pairs of bits with & / | / ^
    genvar stage, j;
    generate
        for (stage = 1; stage <= STAGES; stage = stage + 1) begin : reduction_stages
            localparam integer WIDTH_STAGE = ( ( (WIDTH + (1 << stage) - 1) >> stage) ); // ceil div WIDTH/(2^stage)
            for (j = 0; j < WIDTH_STAGE; j = j + 1) begin : reduce_pairs
                assign and_stage[stage][j] = and_stage[stage-1][2*j] & and_stage[stage-1][2*j+1];
                assign or_stage[stage][j]  = or_stage[stage-1][2*j] | or_stage[stage-1][2*j+1];
                assign xor_stage[stage][j] = xor_stage[stage-1][2*j] ^ xor_stage[stage-1][2*j+1];
            end
        end
    endgenerate

    // Final output is the single bit at the last stage index 0
    assign out_and = and_stage[STAGES][0];
    assign out_or  = or_stage[STAGES][0];
    assign out_xor = xor_stage[STAGES][0];

endmodule