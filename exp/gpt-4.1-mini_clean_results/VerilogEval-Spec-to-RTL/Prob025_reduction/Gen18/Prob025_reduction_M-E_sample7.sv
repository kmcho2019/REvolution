module TopModule (
    input  [7:0] in,
    output       parity
);
    // Number of bits
    localparam N = 8;
    // Number of stages = log2(N)
    localparam STAGES = 3;

    // Declare wires to hold intermediate prefix XOR results
    // prefix_xor[stage][bit]
    wire [N-1:0] prefix_xor [0:STAGES];

    integer i, stage;
    // Stage 0: initial input bits
    assign prefix_xor[0] = in;

    // Generate prefix XOR stages
    generate
        for (stage = 1; stage <= STAGES; stage = stage + 1) begin : prefix_stage
            for (i = 0; i < N; i = i + 1) begin : prefix_bit
                // Distance to XOR with from previous stage
                localparam DIST = 1 << (stage - 1);

                if (i >= DIST) begin
                    assign prefix_xor[stage][i] = prefix_xor[stage-1][i] ^ prefix_xor[stage-1][i - DIST];
                end else begin
                    assign prefix_xor[stage][i] = prefix_xor[stage-1][i];
                end
            end
        end
    endgenerate

    // The parity is the XOR of all bits, which after the last stage is at the last index
    assign parity = prefix_xor[STAGES][N-1];
endmodule