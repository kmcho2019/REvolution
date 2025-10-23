module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // States encoding
    typedef enum logic [2:0] {
        IDLE,       // No match
        S1,         // 1
        S11,        // 11
        S110,       // 110
        FOUND       // 1101 detected
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = data ? S1 : IDLE;
            S1:   next_state = data ? S11 : IDLE;
            S11:  next_state = data ? S11 : S110;
            S110: next_state = data ? FOUND : IDLE;
            FOUND: next_state = FOUND;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign start_shifting = (current_state == FOUND);

endmodule