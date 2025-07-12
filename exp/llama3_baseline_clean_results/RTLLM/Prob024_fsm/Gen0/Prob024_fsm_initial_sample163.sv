module fsm (
    input IN,  // Input signal to the FSM
    input CLK, // Clock signal used for synchronous operation
    input RST, // Reset signal to initialize the FSM
    output reg MATCH // Output signal indicating a match condition based on the FSM state
);

// Define the states for the FSM
enum logic [2:0] {
    IDLE = 3'b001, // Initial state
    S1 = 3'b010,   // State after seeing the first '1'
    S2 = 3'b011,   // State after seeing '10'
    S3 = 3'b100,   // State after seeing '100'
    S4 = 3'b101,   // State after seeing '1001'
    S5 = 3'b110    // State after seeing '10011'
} state, next_state;

// Sequential logic for state transitions
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 0;
    end else begin
        state <= next_state;
        if (state == S5 && IN == 1) begin
            MATCH <= 1;
        end else begin
            MATCH <= 0;
        end
    end
end

// Combinational logic for next state determination
always @* begin
    next_state = state; // Default: stay in the current state
    case (state)
        IDLE: begin
            if (IN == 1) begin
                next_state = S1;
            end
        end
        S1: begin
            if (IN == 0) begin
                next_state = S2;
            end else if (IN == 1) begin
                next_state = S1; // Stay in S1 if another '1' is seen
            end
        end
        S2: begin
            if (IN == 0) begin
                next_state = S3;
            end else if (IN == 1) begin
                next_state = S1; // Reset to S1 if '1' is seen after '10'
            end
        end
        S3: begin
            if (IN == 1) begin
                next_state = S4;
            end else if (IN == 0) begin
                next_state = S2; // If another '0' is seen, go back to S2
            end
        end
        S4: begin
            if (IN == 1) begin
                next_state = S5;
            end else if (IN == 0) begin
                next_state = S2; // If '0' is seen, go back to the start of '100' sequence
            end
        end
        S5: begin
            if (IN == 1) begin
                next_state = S5; // Stay in S5 as long as '1's are seen after '10011'
            end else if (IN == 0) begin
                next_state = S2; // If '0' is seen after '10011', restart from the '100' sequence
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule