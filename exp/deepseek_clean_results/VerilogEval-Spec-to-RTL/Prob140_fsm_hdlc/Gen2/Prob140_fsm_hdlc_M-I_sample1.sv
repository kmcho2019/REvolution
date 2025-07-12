module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // FSM states
    typedef enum logic [2:0] {
        S_RESET,
        S_0,       // Previous bit was 0
        S_1,       // 1 consecutive 1
        S_2,       // 2 consecutive 1s
        S_3,       // 3 consecutive 1s
        S_4,       // 4 consecutive 1s
        S_5,       // 5 consecutive 1s
        S_6,       // 6 consecutive 1s
        S_ERROR    // 7+ consecutive 1s
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S_RESET;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            current_state <= next_state;
            
            // Output logic (registered for one cycle delay)
            disc <= (current_state == S_5) && !in;
            flag <= (current_state == S_6) && !in;
            err <= (current_state == S_ERROR);
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            S_RESET: next_state = in ? S_1 : S_0;
            S_0:     next_state = in ? S_1 : S_0;
            S_1:     next_state = in ? S_2 : S_0;
            S_2:     next_state = in ? S_3 : S_0;
            S_3:     next_state = in ? S_4 : S_0;
            S_4:     next_state = in ? S_5 : S_0;
            S_5:     next_state = in ? S_6 : S_0;
            S_6:     next_state = in ? S_ERROR : S_0;
            S_ERROR: next_state = in ? S_ERROR : S_0;
            default: next_state = S_0;
        endcase
    end

endmodule