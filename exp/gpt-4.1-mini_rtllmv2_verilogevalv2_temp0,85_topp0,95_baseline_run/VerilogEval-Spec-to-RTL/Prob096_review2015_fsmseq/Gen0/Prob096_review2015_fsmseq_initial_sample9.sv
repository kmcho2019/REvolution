module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        S1 = 3'b001,      // matched '1'
        S11 = 3'b010,     // matched "11"
        S110 = 3'b011,    // matched "110"
        MATCHED = 3'b100  // matched "1101"
    } state_t;

    state_t current_state, next_state;

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (data == 1) next_state = S1;
                else next_state = IDLE;
            end
            S1: begin
                if (data == 1) next_state = S11;
                else next_state = IDLE;
            end
            S11: begin
                if (data == 0) next_state = S110;
                else next_state = S11; // stay if another 1 comes (overlapping)
            end
            S110: begin
                if (data == 1) next_state = MATCHED;
                else next_state = IDLE;
            end
            MATCHED: begin
                next_state = MATCHED; // remain matched
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for state and output
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            start_shifting <= 0;
        end else begin
            current_state <= next_state;
            if (next_state == MATCHED)
                start_shifting <= 1;
        end
    end

endmodule