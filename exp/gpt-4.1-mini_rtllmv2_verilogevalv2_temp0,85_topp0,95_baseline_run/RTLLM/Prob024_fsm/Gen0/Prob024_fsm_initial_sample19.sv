module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

// States encoding for the sequence 1 0 0 1 1
// State 0: no match yet
// State 1: matched '1'
// State 2: matched '10'
// State 3: matched '100'
// State 4: matched '1001'
// The sequence length is 5 bits

typedef enum logic [2:0] {
    S0 = 3'd0,
    S1 = 3'd1,
    S2 = 3'd2,
    S3 = 3'd3,
    S4 = 3'd4
} state_t;

state_t current_state, next_state;

always @(*) begin
    // Default values
    next_state = current_state;
    MATCH = 1'b0;

    case (current_state)
        S0: begin
            if (IN == 1'b1)
                next_state = S1;
            else
                next_state = S0;
            MATCH = 1'b0;
        end

        S1: begin
            if (IN == 1'b0)
                next_state = S2;
            else
                // If IN=1, stay in S1 (because '1' can be start of new sequence)
                next_state = S1;
            MATCH = 1'b0;
        end

        S2: begin
            if (IN == 1'b0)
                next_state = S3;
            else if (IN == 1'b1)
                // Input '1' breaks current sequence, but '1' is start of new sequence
                next_state = S1;
            else
                next_state = S0;
            MATCH = 1'b0;
        end

        S3: begin
            if (IN == 1'b1)
                next_state = S4;
            else if (IN == 1'b0)
                // Reset to S0, no partial sequence matched
                next_state = S0;
            MATCH = 1'b0;
        end

        S4: begin
            // If input is 1, sequence matched: 10011
            // Output MATCH=1 at this input
            if (IN == 1'b1) begin
                MATCH = 1'b1;
                // Overlap detection: after detecting 10011, 
                // next state depends on current input '1' which can be start of a new sequence
                next_state = S1;
            end else if (IN == 1'b0) begin
                // Input '0' after full match, fallback to S2 because sequence 100 can start again from here
                MATCH = 1'b0;
                next_state = S2;
            end else begin
                MATCH = 1'b0;
                next_state = S0;
            end
        end

        default: begin
            next_state = S0;
            MATCH = 1'b0;
        end
    endcase
end

// Sequential state update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        // MATCH is assigned combinationally in always @(*) block, 
        // but in Mealy FSM it's usually combinational output.
        // To meet the specification that MATCH updates on clock, 
        // assign MATCH here as well:
        MATCH <= MATCH;
    end
end

endmodule