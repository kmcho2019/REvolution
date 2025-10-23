module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot state encoding representing progress in matching "10011"
    localparam [4:0]
        S0 = 5'b00001, // no bits matched (idle)
        S1 = 5'b00010, // matched '1'
        S2 = 5'b00100, // matched '10'
        S3 = 5'b01000, // matched '100'
        S4 = 5'b10000; // matched '1001'

    reg [4:0] state, next_state;

    // Sequential state update: synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational next state logic: 
    // Merge the explicit multiple-source transitions from Example 1 with clear case structure.
    always @(*) begin
        // Default next_state is idle state; will be overridden below
        next_state = 5'b00000;

        // For each active state bit, determine next partial matches according to input
        // Overlapping sequences supported by setting multiple bits if needed, then ORed.

        // S0: No bits matched yet
        if (state[S0]) begin
            if (IN == 1'b1)
                next_state[S1] = 1'b1; // match first '1'
            else
                next_state[S0] = 1'b1; // remain idle
        end

        // S1: matched '1'
        if (state[S1]) begin
            if (IN == 1'b0)
                next_state[S2] = 1'b1; // matched '10'
            else
                next_state[S1] = 1'b1; // still matched '1' (start again)
        end

        // S2: matched '10'
        if (state[S2]) begin
            if (IN == 1'b0)
                next_state[S3] = 1'b1; // matched '100'
            else
                next_state[S1] = 1'b1; // restart matched '1'
        end

        // S3: matched '100'
        if (state[S3]) begin
            if (IN == 1'b1)
                next_state[S4] = 1'b1; // matched '1001'
            else
                next_state[S0] = 1'b1; // reset to idle
        end

        // S4: matched '1001'
        if (state[S4]) begin
            if (IN == 1'b1)
                next_state[S1] = 1'b1; // full match on next clock with IN=1, also start new match
            else
                next_state[S2] = 1'b1; // sequence suffix '10' partial match
        end

        // Safety fallback: ensure at least S0 is active if next_state is empty
        if (next_state == 5'b00000)
            next_state = S0;
    end

    // Mealy output: MATCH is 1 when state is S4 and IN=1 (sequence "10011" detected)
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule