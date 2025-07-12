module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE,     // Reset state, behaves as though previous input were 0
    ONE,      // One '1' detected
    ONES_2,   // Two consecutive '1's detected
    ONES_3,   // Three consecutive '1's detected
    ONES_4,   // Four consecutive '1's detected
    ONES_5,   // Five consecutive '1's detected, discard next bit
    FLAG,     // Six consecutive '1's detected, signal flag
    ERROR     // Seven or more consecutive '1's detected, signal error
} state, next_state;

// Output logic
logic disc_next, flag_next, err_next;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= next_state;
        disc <= disc_next;
        flag <= flag_next;
        err <= err_next;
    end
end

// Combinational logic
always_comb begin
    // Default outputs
    disc_next = 1'b0;
    flag_next = 1'b0;
    err_next = 1'b0;

    case (state)
        IDLE: begin
            if (in) begin
                next_state = ONE;
            end else begin
                next_state = IDLE;
            end
        end
        ONE: begin
            if (in) begin
                next_state = ONES_2;
            end else begin
                next_state = IDLE;
            end
        end
        ONES_2: begin
            if (in) begin
                next_state = ONES_3;
            end else begin
                next_state = IDLE;
            end
        end
        ONES_3: begin
            if (in) begin
                next_state = ONES_4;
            end else begin
                next_state = IDLE;
            end
        end
        ONES_4: begin
            if (in) begin
                next_state = ONES_5;
            end else begin
                next_state = IDLE;
            end
        end
        ONES_5: begin
            if (in) begin
                next_state = FLAG;
            end else begin
                next_state = IDLE;
                disc_next = 1'b1;
            end
        end
        FLAG: begin
            flag_next = 1'b1;
            if (in) begin
                next_state = ERROR;
            end else begin
                next_state = IDLE;
            end
        end
        ERROR: begin
            err_next = 1'b1;
            if (~in) begin
                next_state = IDLE;
            end else begin
                next_state = ERROR;
            end
        end
    endcase
end

endmodule