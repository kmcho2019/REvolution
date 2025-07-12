module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot state encoding for the sequence "10011"
    // States:
    // S0: no match (000001)
    // S1: matched '1'     (000010)
    // S2: matched '10'    (000100)
    // S3: matched '100'   (001000)
    // S4: matched '1001'  (010000)
    // S5: matched '10011' (100000) - final matched state (used internally for clarity)

    reg [5:0] state, next_state;

    // Define state bits for readability
    wire S0 = state[0];
    wire S1 = state[1];
    wire S2 = state[2];
    wire S3 = state[3];
    wire S4 = state[4];
    wire S5 = state[5]; // not used as a stable state, but useful for clarity

    // Next state logic combinational
    always @(*) begin
        // Default to zero next state
        next_state = 6'b000000;

        // From S0: waiting for first '1'
        if (S0) begin
            if (IN)
                next_state = 6'b000010; // S1
            else
                next_state = 6'b000001; // S0
        end

        // From S1: matched '1'
        else if (S1) begin
            if (IN == 1'b0)
                next_state = 6'b000100; // S2
            else
                next_state = 6'b000010; // stay in S1 if IN=1 (sequence restart)
        end

        // From S2: matched '10'
        else if (S2) begin
            if (IN == 1'b0)
                next_state = 6'b001000; // S3
            else
                next_state = 6'b000010; // S1 (restart with '1')
        end

        // From S3: matched '100'
        else if (S3) begin
            if (IN)
                next_state = 6'b010000; // S4
            else
                next_state = 6'b000001; // S0 (no match)
        end

        // From S4: matched '1001'
        else if (S4) begin
            if (IN) begin
                // Full sequence detected here (10011)
                // Next state needs to consider overlapping:
                // After full match, next state depends on input IN:
                // IN=1 -> go to S1 (sequence restart)
                // IN=0 -> go to S2 (since last bits "00" can start new seq)
                next_state = 6'b000010; // S1
            end
            else
                next_state = 6'b000100; // S2
        end

        else begin
            // Unknown state, reset to S0
            next_state = 6'b000001;
        end
    end

    // State register with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= 6'b000001; // S0 active on reset
        else
            state <= next_state;
    end

    // Mealy output MATCH asserted when in S4 and IN=1 (last bit detected)
    assign MATCH = (S4 && IN);

endmodule