module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Enum for states
enum logic [2:0] {
    IDLE,     // Initial state, assumes previous bit was 0
    ONE,      // 1 consecutive 1
    TWO,      // 2 consecutive 1s
    THREE,    // 3 consecutive 1s
    FOUR,     // 4 consecutive 1s
    FIVE,     // 5 consecutive 1s, need to discard next bit if it's 0
    FLAG,     // Flag detected (6 consecutive 1s followed by 0)
    ERROR     // 7 or more consecutive 1s
} state, nextState;

// Outputs are determined by the current state
always_comb begin
    disc = (state == FIVE && in == 0); // If in FIVE state and next bit is 0, discard it
    flag = (state == FLAG); // If in FLAG state, signal flag
    err = (state == ERROR); // If in ERROR state, signal error
end

// State transitions
always_comb begin
    case (state)
        IDLE: begin
            if (in) nextState = ONE;
            else nextState = IDLE;
        end
        ONE: begin
            if (in) nextState = TWO;
            else nextState = IDLE;
        end
        TWO: begin
            if (in) nextState = THREE;
            else nextState = IDLE;
        end
        THREE: begin
            if (in) nextState = FOUR;
            else nextState = IDLE;
        end
        FOUR: begin
            if (in) nextState = FIVE;
            else nextState = IDLE;
        end
        FIVE: begin
            if (in) nextState = ERROR; // 6 consecutive 1s, moving towards error
            else nextState = FLAG; // 6 consecutive 1s followed by 0, flag detected
        end
        FLAG: begin
            nextState = IDLE; // After flag, reset to IDLE
        end
        ERROR: begin
            if (in) nextState = ERROR; // Stay in error if more 1s
            else nextState = IDLE; // Reset to IDLE if 0 encountered
        end
        default: nextState = IDLE;
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= nextState;
    end
end

endmodule