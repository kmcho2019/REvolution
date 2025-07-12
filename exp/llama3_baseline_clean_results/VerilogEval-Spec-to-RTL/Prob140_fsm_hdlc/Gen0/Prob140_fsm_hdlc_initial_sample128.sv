module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Enumerate the states
typedef enum logic [2:0] {
    S_RESET,
    S_ZERO,
    S_ONE,
    S_TWO_ONES,
    S_THREE_ONES,
    S_FOUR_ONES,
    S_FIVE_ONES,
    S_FLAG,
    S_ERROR
} state_t;

// Current state and next state
state_t current_state, next_state;

// Output signals
logic disc_next, flag_next, err_next;

// Combinational logic for next state and output signals
always_comb begin
    // Initialize next state and output signals
    next_state = current_state;
    disc_next = 1'b0;
    flag_next = 1'b0;
    err_next = 1'b0;

    case (current_state)
        S_RESET: begin
            if (in == 1'b0) begin
                next_state = S_ZERO;
            end else begin
                next_state = S_ONE;
            end
        end
        S_ZERO: begin
            if (in == 1'b0) begin
                next_state = S_ZERO;
            end else begin
                next_state = S_ONE;
            end
        end
        S_ONE: begin
            if (in == 1'b0) begin
                next_state = S_ZERO;
            end else begin
                next_state = S_TWO_ONES;
            end
        end
        S_TWO_ONES: begin
            if (in == 1'b0) begin
                next_state = S_ZERO;
            end else begin
                next_state = S_THREE_ONES;
            end
        end
        S_THREE_ONES: begin
            if (in == 1'b0) begin
                next_state = S_ZERO;
            end else begin
                next_state = S_FOUR_ONES;
            end
        end
        S_FOUR_ONES: begin
            if (in == 1'b0) begin
                next_state = S_ZERO;
            end else begin
                next_state = S_FIVE_ONES;
            end
        end
        S_FIVE_ONES: begin
            if (in == 1'b0) begin
                next_state = S_ZERO;
                disc_next = 1'b1;
            end else begin
                next_state = S_FLAG;
            end
        end
        S_FLAG: begin
            if (in == 1'b0) begin
                next_state = S_ZERO;
                flag_next = 1'b1;
            end else begin
                next_state = S_ERROR;
            end
        end
        S_ERROR: begin
            if (in == 1'b0) begin
                next_state = S_ZERO;
            end else begin
                next_state = S_ERROR;
                err_next = 1'b1;
            end
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= S_RESET;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        current_state <= next_state;
        disc <= disc_next;
        flag <= flag_next;
        err <= err_next;
    end
end

endmodule