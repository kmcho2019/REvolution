module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states for the FSM
enum logic [2:0] {
    IDLE = 3'b000,
    FIRST_ONE = 3'b001,
    FIRST_ZERO = 3'b010,
    SECOND_ONE = 3'b011,
    SEQUENCE_FOUND = 3'b100
} state, nextState;

always_comb begin
    // Default next state is the current state
    nextState = state;

    case(state)
        IDLE: begin
            if (data == 1'b1) begin
                // If data is 1, move to FIRST_ONE state
                nextState = FIRST_ONE;
            end else begin
                // If data is 0, stay in IDLE state
                nextState = IDLE;
            end
        end

        FIRST_ONE: begin
            if (data == 1'b1) begin
                // If data is 1, stay in FIRST_ONE state
                nextState = FIRST_ONE;
            end else if (data == 1'b0) begin
                // If data is 0, move to FIRST_ZERO state
                nextState = FIRST_ZERO;
            end
        end

        FIRST_ZERO: begin
            if (data == 1'b1) begin
                // If data is 1, move to SECOND_ONE state
                nextState = SECOND_ONE;
            end else begin
                // If data is 0, move back to IDLE state
                nextState = IDLE;
            end
        end

        SECOND_ONE: begin
            if (data == 1'b0) begin
                // If data is 0, move to SEQUENCE_FOUND state
                nextState = SEQUENCE_FOUND;
            end else if (data == 1'b1) begin
                // If data is 1, move back to FIRST_ONE state
                nextState = FIRST_ONE;
            end
        end

        SEQUENCE_FOUND: begin
            // Stay in SEQUENCE_FOUND state forever until reset
            nextState = SEQUENCE_FOUND;
        end

        default: begin
            // Default next state is IDLE
            nextState = IDLE;
        end
    endcase
end

always_ff @(posedge clk) begin
    if (reset == 1'b1) begin
        // Reset to IDLE state and clear start_shifting when reset is high
        state <= IDLE;
        start_shifting <= 1'b0;
    end else begin
        // Move to next state
        state <= nextState;
        // Set start_shifting to 1 if in SEQUENCE_FOUND state
        start_shifting <= (state == SEQUENCE_FOUND) ? 1'b1 : 1'b0;
    end
end

endmodule