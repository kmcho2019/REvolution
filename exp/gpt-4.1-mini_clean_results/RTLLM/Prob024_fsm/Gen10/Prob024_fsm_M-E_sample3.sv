module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Sequence to detect: 1 0 0 1 1
    // One-hot states encoding partial match progress:
    // S0 - no bits matched (idle)
    // S1 - matched '1'
    // S2 - matched '10'
    // S3 - matched '100'
    // S4 - matched '1001'

    reg [4:0] state, next_state;

    // State bits meanings:
    // state[0] = S0 (idle)
    // state[1] = S1 (matched '1')
    // state[2] = S2 (matched '10')
    // state[3] = S3 (matched '100')
    // state[4] = S4 (matched '1001')

    // Initialize state to idle
    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= 5'b00001; // S0 active
        else
            state <= next_state;
    end

    // Next state logic: update partial matches based on input IN
    always @(*) begin
        next_state = 5'b00000;

        // S0 always active if no partial match or pattern restart
        // S0 active if no other state matches and IN=0 (no start)
        // but we will set it last if no other matches

        // From S0: if IN==1, move to S1, else remain in S0
        if (IN == 1'b1)
            next_state[1] = 1'b1; // matched first '1'
        else
            next_state[0] = 1'b1; // remain idle

        // From S1 (matched '1'):
        // If IN==0, matched '10' => S2
        // If IN==1, could start new pattern so S1 again
        if (state[1]) begin
            if (IN == 1'b0)
                next_state[2] = 1'b1;
            else
                next_state[1] = 1'b1;
        end

        // From S2 (matched '10'):
        // If IN==0, matched '100' => S3
        // If IN==1, restart from S1 (possible overlapping pattern)
        if (state[2]) begin
            if (IN == 1'b0)
                next_state[3] = 1'b1;
            else
                next_state[1] = 1'b1;
        end

        // From S3 (matched '100'):
        // If IN==1, matched '1001' => S4
        // else break pattern => S0
        if (state[3]) begin
            if (IN == 1'b1)
                next_state[4] = 1'b1;
            else
                next_state[0] = 1'b1;
        end

        // From S4 (matched '1001'):
        // If IN==1, full sequence "10011" matched on this clock cycle (Mealy output)
        // Also, overlapping allowed, so for IN==1, restart with S1 (start new pattern)
        // For IN==0, transition to S2 (matched '10'), since sequence suffix '10' can be next
        if (state[4]) begin
            if (IN == 1'b1)
                next_state[1] = 1'b1;
            else
                next_state[2] = 1'b1;
        end

        // Make sure at least one state bit is set (idle fallback)
        if (next_state == 5'b00000)
            next_state[0] = 1'b1; // fallback idle
    end

    // MATCH output: Mealy output generated combinationally
    // MATCH = 1 when currently in S4 and input IN==1, completing the sequence "10011"
    assign MATCH = (state[4] == 1'b1) && (IN == 1'b1);

endmodule