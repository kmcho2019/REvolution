module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // Define states for sequence detection
    typedef enum logic [2:0] {
        S_IDLE,
        S_1,
        S_11,
        S_110,
        S_DETECTED
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S_IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            S_IDLE:   next_state = data ? S_1 : S_IDLE;
            S_1:      next_state = data ? S_11 : S_IDLE;
            S_11:     next_state = data ? S_11 : S_110;
            S_110:    next_state = data ? S_DETECTED : S_IDLE;
            S_DETECTED: next_state = S_DETECTED;
            default:  next_state = S_IDLE;
        endcase
    end

    // Output logic
    assign start_shifting = (current_state == S_DETECTED);

endmodule