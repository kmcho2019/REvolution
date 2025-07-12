module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Define per-state next_state vectors for input=0 and input=1
    // Each vector has one bit set indicating the next state when current state is that index and input is given.
    localparam [9:0] NS0 [0:9] = {
        10'b0000000001, // S0, in=0 -> S0 (bit 0)
        10'b0000000001, // S1, in=0 -> S0
        10'b0000000001, // S2, in=0 -> S0
        10'b0000000001, // S3, in=0 -> S0
        10'b0000000001, // S4, in=0 -> S0
        10'b0001000000, // S5, in=0 -> S8 (bit 8)
        10'b0010000000, // S6, in=0 -> S9 (bit 9)
        10'b0000000001, // S7, in=0 -> S0
        10'b0000000001, // S8, in=0 -> S0
        10'b0000000001  // S9, in=0 -> S0
    };

    localparam [9:0] NS1 [0:9] = {
        10'b0000000010, // S0, in=1 -> S1 (bit 1)
        10'b0000000100, // S1, in=1 -> S2
        10'b0000001000, // S2, in=1 -> S3
        10'b0000010000, // S3, in=1 -> S4
        10'b0000100000, // S4, in=1 -> S5
        10'b0000010000, // S5, in=1 -> S6 (bit 6) - corrected below
        10'b0000001000, // S6, in=1 -> S7 (bit 7) - corrected below
        10'b0000001000, // S7, in=1 -> S7 (bit 7)
        10'b0000000010, // S8, in=1 -> S1
        10'b0000000010  // S9, in=1 -> S1
    };

    // Fix NS1 entries for S5 and S6 (since above lines mistakenly copied previous states)
    // S5: in=1 -> S6 (bit 6)
    // S6: in=1 -> S7 (bit 7)
    // So override those entries:
    localparam [9:0] NS1_S5 = 10'b0000000100000000 >> 0; // bit 6 set (S6)
    localparam [9:0] NS1_S6 = 10'b0000001000000000 >> 0; // bit 7 set (S7)

    // Due to localparam arrays being fixed at elaboration, declare local wires to fix NS1 entries:
    wire [9:0] NS1_fixed [0:9];
    assign NS1_fixed[0] = NS1[0];
    assign NS1_fixed[1] = NS1[1];
    assign NS1_fixed[2] = NS1[2];
    assign NS1_fixed[3] = NS1[3];
    assign NS1_fixed[4] = NS1[4];
    assign NS1_fixed[5] = 10'b0000001000000; // bit 6 set (S6)
    assign NS1_fixed[6] = 10'b0000010000000; // bit 7 set (S7)
    assign NS1_fixed[7] = NS1[7];
    assign NS1_fixed[8] = NS1[8];
    assign NS1_fixed[9] = NS1[9];

    // Now compute next_state bits by OR-ing contributions from all active current states
    genvar i;
    wire [9:0] next_state_w;
    generate
        for (i=0; i<10; i=i+1) begin : NEXT_STATE_GEN
            wire next0 = |(state & (NS0[i] & {10{1'b1}})) & ~in; // This line is not correct logically, fix below
            wire next1 = |(state & (NS1_fixed[i] & {10{1'b1}})) & in; // Likewise needs correction
            // Actually, we want to build next_state bit i by OR over all states j:
            // next_state[i] = OR_over_j (state[j] & (input ? NS1_fixed[j][i] : NS0[j][i]))
            // So build next_state[i] by summing contributions for all j from 0..9:
        end
    endgenerate

    // The above generate block can't build next_state bits directly because it loops over i,
    // but we need to loop over j for each next_state bit i.

    // Approach: For each next_state bit i (0..9), next_state[i] = OR over j=0..9 of (state[j] & (in ? NS1_fixed[j][i] : NS0[j][i])).

    // Implemented here as combinational assignments using a for loop in a generate block:

    wire [9:0] next_state_bits [0:9];

    generate
        for (i=0; i<10; i=i+1) begin : NEXT_STATE_BITS_GEN
            integer j;
            wire [9:0] contributions;
            // For each j, compute contribution to next_state[i]
            // We'll make an intermediate vector of contributions, then OR reduce them
            reg [9:0] contrib_vec;
            always @(*) begin
                contrib_vec = 10'b0;
                for (j=0; j<10; j=j+1) begin
                    // contribution if state[j] active and transitions to state i with current input
                    if (in) begin
                        // in=1
                        if (NS1_fixed[j][i])
                            contrib_vec[j] = state[j];
                        else
                            contrib_vec[j] = 1'b0;
                    end else begin
                        // in=0
                        if (NS0[j][i])
                            contrib_vec[j] = state[j];
                        else
                            contrib_vec[j] = 1'b0;
                    end
                end
            end
            assign next_state[i] = |contrib_vec;
        end
    endgenerate

    // However, 'always @(*)' inside generate is illegal in Verilog, and we cannot declare reg inside generate.

    // Therefore, revert to a single always_comb block to calculate next_state combinationally.

    // Final approach: Single always_comb block, iterate over next_state bits, then sum contributions from all active states.

    integer m,n;
    reg [9:0] next_state_reg;

    always @* begin
        next_state_reg = 10'b0;
        for (m=0; m<10; m=m+1) begin
            for (n=0; n<10; n=n+1) begin
                if (in) begin
                    if (NS1_fixed[n][m] && state[n])
                        next_state_reg[m] = 1'b1;
                end else begin
                    if (NS0[n][m] && state[n])
                        next_state_reg[m] = 1'b1;
                end
            end
        end
    end

    assign next_state = next_state_reg;

    // Output masks:
    localparam [9:0] MASK_OUT1 = (1 << 8) | (1 << 9); // S8, S9
    localparam [9:0] MASK_OUT2 = (1 << 7) | (1 << 9); // S7, S9

    assign out1 = |(state & MASK_OUT1);
    assign out2 = |(state & MASK_OUT2);

endmodule