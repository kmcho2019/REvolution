module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Define states
enum logic [2:0] {
    S0,  // Initial state or after seeing a '0'
    S1, S2, S3, S4, S5,  // Counting states for consecutive '1's
    S6,  // State to flag the beginning/end of a frame
    S_ERR  // Error state for 7 or more '1's
} state, next_state;

// Output logic
always_comb begin
    disc = (state == S5 && in == 0);  // Discard bit after 5 '1's
    flag = (state == S6 && in == 0);  // Flag after 6 '1's and a '0'
    err = (state == S_ERR);  // Error on 7 or more '1's
end

// State machine logic
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= S0;  // Reset to S0 on reset
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        S0: begin
            if (in) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1, S2, S3, S4: begin
            if (in) begin
                case (state)
                    S1: next_state = S2;
                    S2: next_state = S3;
                    S3: next_state = S4;
                    S4: next_state = S5;
                    default: next_state = S0;
                endcase
            end else begin
                next_state = S0;
            end
        end
        S5: begin
            if (in) begin
                next_state = S_ERR;  // 7 or more '1's is an error
            end else begin
                next_state = S6;  // After 5 '1's and a '0', transition to S6
            end
        end
        S6: begin
            next_state = S0;  // After flagging, reset state
        end
        S_ERR: begin
            next_state = S_ERR;  // Stay in error state until reset
        end
        default: next_state = S0;
    endcase
end

endmodule