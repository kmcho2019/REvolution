module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot encoding of states for partial matches of "10011"
    // state[0] = S0: no match / idle
    // state[1] = S1: matched '1'
    // state[2] = S2: matched '10'
    // state[3] = S3: matched '100'
    // state[4] = S4: matched '1001'

    reg [4:0] state, next_state;

    // State register with synchronous reset
    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= 5'b00001; // S0 active
        else
            state <= next_state;
    end

    // Next state combinational logic (Boolean equations for clarity and efficiency)
    always @(*) begin
        // Initialize next_state with zeros
        next_state = 5'b00000;

        // From S0 (idle)
        // If IN=1: go to S1
        // Else remain in S0
        next_state[0] = (~IN) & (state[0] | state[3]); // also from S3 if IN=0 go to S0
        next_state[1] = (IN & state[0])                // S0 -> S1 if IN=1
                      | (IN & state[1])                // S1 with IN=1 stays S1
                      | (IN & state[2])                // S2 with IN=1 overlaps restart to S1
                      | (IN & state[4]);               // S4 with IN=1 overlaps restart to S1

        next_state[2] = (~IN & state[1])               // S1 -> S2 if IN=0
                      | (~IN & state[4]);              // S4 -> S2 if IN=0

        next_state[3] = (~IN & state[2]);              // S2 -> S3 if IN=0

        next_state[4] = (IN & state[3]);               // S3 -> S4 if IN=1

        // Safety: if no next state selected, stay in idle
        if (next_state == 5'b00000)
            next_state[0] = 1'b1;
    end

    // MATCH signal: asserted combinationally when in S4 and IN=1 (Mealy output)
    assign MATCH = state[4] & IN;

endmodule