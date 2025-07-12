module TopModule(
    input        in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    always @* begin
        // Initialize next_state to zero
        next_state = 10'b0;

        // next_state[0] hierarchical grouping (to reduce fan-in)
        // Group states that transition to S0 on input=0:
        // Group 1: S0, S1, S2
        // Group 2: S3, S4
        // Group 3: S7, S8, S9
        wire ns0_group1 = (state[0] | state[1] | state[2]) & zero_in;
        wire ns0_group2 = (state[3] | state[4]) & zero_in;
        wire ns0_group3 = (state[7] | state[8] | state[9]) & zero_in;
        next_state[0] = ns0_group1 | ns0_group2 | ns0_group3;

        // Other next_state bits updated cumulatively based on transitions from each active state

        // S0 transitions
        if (state[0]) begin
            next_state[1] = next_state[1] | one_in;
        end

        // S1 transitions
        if (state[1]) begin
            next_state[0] = next_state[0] | zero_in; // note: already included, but re-assert to cover multiple active states
            next_state[2] = next_state[2] | one_in;
        end

        // S2 transitions
        if (state[2]) begin
            next_state[0] = next_state[0] | zero_in;
            next_state[3] = next_state[3] | one_in;
        end

        // S3 transitions
        if (state[3]) begin
            next_state[0] = next_state[0] | zero_in;
            next_state[4] = next_state[4] | one_in;
        end

        // S4 transitions
        if (state[4]) begin
            next_state[0] = next_state[0] | zero_in;
            next_state[5] = next_state[5] | one_in;
        end

        // S5 transitions
        if (state[5]) begin
            next_state[8] = next_state[8] | zero_in;
            next_state[6] = next_state[6] | one_in;
        end

        // S6 transitions
        if (state[6]) begin
            next_state[9] = next_state[9] | zero_in;
            next_state[7] = next_state[7] | one_in;
        end

        // S7 transitions
        if (state[7]) begin
            next_state[0] = next_state[0] | zero_in;
            next_state[7] = next_state[7] | one_in;
        end

        // S8 transitions
        if (state[8]) begin
            next_state[0] = next_state[0] | zero_in;
            next_state[1] = next_state[1] | one_in;
        end

        // S9 transitions
        if (state[9]) begin
            next_state[0] = next_state[0] | zero_in;
            next_state[1] = next_state[1] | one_in;
        end
    end

    // Output logic:
    // out1 = 1 when state is S8 or S9 (bits 8 or 9)
    // out2 = 1 when state is S7 or S9 (bits 7 or 9)

    localparam [9:0] MASK_OUT1 = 10'b1100000000; // bits 9 and 8
    localparam [9:0] MASK_OUT2 = 10'b0100000000; // bits 9 and 7 set via or below

    // Explicitly include bit 9 for out2 mask as per spec
    wire out2_mask = (state[7] | state[9]);

    assign out1 = |(state & MASK_OUT1);
    assign out2 = out2_mask;

endmodule