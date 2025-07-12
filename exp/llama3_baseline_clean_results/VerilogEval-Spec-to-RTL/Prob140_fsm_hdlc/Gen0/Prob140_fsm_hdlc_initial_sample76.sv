module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Enum for the states of the FSM
enum logic [3:0] {
    IDLE,  // Reset state, behaves as if previous input was 0
    ONE,   // Seen 1 after 0 or reset
    TWO_ONES, // Seen two consecutive 1s
    THREE_ONES, // Seen three consecutive 1s
    FOUR_ONES, // Seen four consecutive 1s
    FIVE_ONES, // Seen five consecutive 1s, expecting a 0
    FLAG_SEEN, // Seen six consecutive 1s, flag
    ERROR // Seen seven or more consecutive 1s, error
} state, next_state;

// Default output values
logic disc_default = 1'b0;
logic flag_default = 1'b0;
logic err_default = 1'b0;

// Output logic based on current state
always_comb begin
    disc = disc_default;
    flag = flag_default;
    err = err_default;
    case(state)
        FIVE_ONES: begin
            if (!in) disc = 1'b1; // Discard the zero after five 1s
        end
        FLAG_SEEN: flag = 1'b1; // Flag seen
        ERROR: err = 1'b1; // Error, seven or more consecutive 1s
    endcase
end

// Next state logic
always_comb begin
    next_state = state;
    case(state)
        IDLE: begin
            if (in) next_state = ONE;
        end
        ONE: begin
            if (in) next_state = TWO_ONES;
            else next_state = IDLE;
        end
        TWO_ONES: begin
            if (in) next_state = THREE_ONES;
            else next_state = IDLE;
        end
        THREE_ONES: begin
            if (in) next_state = FOUR_ONES;
            else next_state = IDLE;
        end
        FOUR_ONES: begin
            if (in) next_state = FIVE_ONES;
            else next_state = IDLE;
        end
        FIVE_ONES: begin
            if (in) next_state = ERROR; // Error, six or more consecutive 1s
            else next_state = IDLE; // Seen a zero after five 1s, discard and reset
        end
        FLAG_SEEN: begin
            next_state = IDLE; // After flag, reset to IDLE
        end
        ERROR: begin
            if (!in) next_state = IDLE; // Reset after seeing a zero
        end
    endcase
end

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule