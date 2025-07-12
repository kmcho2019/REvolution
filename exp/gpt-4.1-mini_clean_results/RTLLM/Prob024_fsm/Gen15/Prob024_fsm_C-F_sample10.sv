module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot encoding of states representing partial matches of sequence "10011"
    // State bits:
    // S0: no bits matched (idle)
    // S1: matched '1'
    // S2: matched '10'
    // S3: matched '100'
    // S4: matched '1001'

    reg [4:0] state, next_state;

    // Synchronous state register update with asynchronous reset
    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= 5'b00001; // S0 active
        else
            state <= next_state;
    end

    // Combinational next-state logic for one-hot states
    always @(*) begin
        // Default no states active
        next_state = 5'b00000;

        // From S0 (no bits matched)
        // If IN=1, partial match '1' => S1
        // else remain in S0
        if (state[0]) begin
            if (IN)
                next_state[1] = 1'b1; // S1
            else
                next_state[0] = 1'b1; // S0
        end

        // From S1 (matched '1')
        // If IN=0, matched '10' => S2
        // If IN=1, still '1' matched (stay in S1, supports overlapping)
        if (state[1]) begin
            if (IN == 1'b0)
                next_state[2] = 1'b1; // S2
            else
                next_state[1] = 1'b1; // S1
        end

        // From S2 (matched '10')
        // If IN=0, matched '100' => S3
        // If IN=1, restart partial match at '1' => S1 (overlap)
        if (state[2]) begin
            if (IN == 1'b0)
                next_state[3] = 1'b1; // S3
            else
                next_state[1] = 1'b1; // S1
        end

        // From S3 (matched '100')
        // If IN=1, matched '1001' => S4
        // Else, reset to S0
        if (state[3]) begin
            if (IN == 1'b1)
                next_state[4] = 1'b1; // S4
            else
                next_state[0] = 1'b1; // S0
        end

        // From S4 (matched '1001')
        // If IN=1, sequence "10011" matched at this bit (MATCH=1), then restart at S1
        // If IN=0, partial matched '10' => S2 (since '10' is suffix of sequence start)
        if (state[4]) begin
            if (IN == 1'b1)
                next_state[1] = 1'b1; // S1
            else
                next_state[2] = 1'b1; // S2
        end

        // If no bits set (should not happen), default to S0
        if (next_state == 5'b00000)
            next_state[0] = 1'b1;
    end

    // Mealy output MATCH: asserted combinationally when full sequence matched
    // MATCH = 1 when currently in S4 and IN=1 (final input bit of sequence)
    assign MATCH = (state[4] && IN);

endmodule