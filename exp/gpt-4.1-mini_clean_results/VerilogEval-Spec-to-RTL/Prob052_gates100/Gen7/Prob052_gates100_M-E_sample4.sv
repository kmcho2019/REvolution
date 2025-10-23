module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Number of inputs
    localparam N = 100;

    // Calculate number of stages needed (ceil of log2(N))
    function integer clog2;
        input integer value;
        integer i;
        begin
            clog2 = 0;
            for (i = value - 1; i > 0; i = i >> 1)
                clog2 = clog2 + 1;
        end
    endfunction

    localparam STAGES = clog2(N);

    // Define arrays for intermediate wires per stage
    wire [N-1:0] stage_and [0:STAGES];
    wire [N-1:0] stage_or  [0:STAGES];
    wire [N-1:0] stage_xor [0:STAGES];

    integer i;

    // Stage 0: inputs assigned to stage 0 wires
    // Extend input bits to arrays with unused bits set to 1 (AND), 0 (OR), 0 (XOR)
    // so that the last stage can reduce properly without care for out of range indices.
    generate
        for (i = 0; i < N; i = i + 1) begin : input_assign
            assign stage_and[0][i] = in[i];
            assign stage_or[0][i]  = in[i];
            assign stage_xor[0][i] = in[i];
        end
        for (i = N; i < (1 << STAGES); i = i + 1) begin : pad_bits
            // Pad bits for out-of-range inputs:
            assign stage_and[0][i] = 1'b1; // Neutral element for AND
            assign stage_or[0][i]  = 1'b0; // Neutral element for OR
            assign stage_xor[0][i] = 1'b0; // Neutral element for XOR
        end
    endgenerate

    // Build tree for each stage
    generate
        genvar stage, idx;
        for (stage = 0; stage < STAGES; stage = stage + 1) begin : reduction_stages
            for (idx = 0; idx < (1 << (STAGES - 1)); idx = idx + 1) begin : combine_pairs
                // Each next stage node is AND, OR, XOR of two nodes from previous stage
                // If the index*2 + 1 is out of range, treat as neutral element as above (already padded)
                localparam int left_idx = idx * 2;
                localparam int right_idx = left_idx + 1;
                assign stage_and[stage + 1][idx] = stage_and[stage][left_idx] & stage_and[stage][right_idx];
                assign stage_or[stage + 1][idx]  = stage_or[stage][left_idx]  | stage_or[stage][right_idx];
                assign stage_xor[stage + 1][idx] = stage_xor[stage][left_idx] ^ stage_xor[stage][right_idx];
            end
        end
    endgenerate

    // The final output is at the last stage at index 0
    assign out_and = stage_and[STAGES][0];
    assign out_or  = stage_or[STAGES][0];
    assign out_xor = stage_xor[STAGES][0];

endmodule