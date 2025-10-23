module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding
    typedef enum logic [2:0] {
        S_IDLE,     // 0 consecutive 1s
        S_1,        // 1 consecutive 1
        S_2,        // 2 consecutive 1s
        S_3,        // 3 consecutive 1s
        S_4,        // 4 consecutive 1s
        S_5,        // 5 consecutive 1s
        S_6,        // 6 consecutive 1s
        S_ERR       // Error state (7+ consecutive 1s)
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
            S_IDLE: next_state = in ? S_1 : S_IDLE;
            S_1:    next_state = in ? S_2 : S_IDLE;
            S_2:    next_state = in ? S_3 : S_IDLE;
            S_3:    next_state = in ? S_4 : S_IDLE;
            S_4:    next_state = in ? S_5 : S_IDLE;
            S_5:    next_state = in ? S_6 : S_IDLE;
            S_6:    next_state = in ? S_ERR : S_IDLE;
            S_ERR:  next_state = in ? S_ERR : S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    // Output detection logic (registered)
    always @(posedge clk) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Detect 0111110 (disc)
            disc <= (current_state == S_5) && !in;
            
            // Detect 01111110 (flag)
            flag <= (current_state == S_6) && !in;
            
            // Detect 01111111... (err)
            err <= (current_state == S_6 && in) || (current_state == S_ERR);
        end
    end

endmodule