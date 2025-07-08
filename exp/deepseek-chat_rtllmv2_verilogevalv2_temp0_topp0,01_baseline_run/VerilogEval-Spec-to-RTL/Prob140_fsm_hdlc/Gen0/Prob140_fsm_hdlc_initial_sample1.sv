module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // Define states
    typedef enum logic [2:0] {
        STATE_0,    // 0 consecutive 1s
        STATE_1,    // 1 consecutive 1
        STATE_2,    // 2 consecutive 1s
        STATE_3,    // 3 consecutive 1s
        STATE_4,    // 4 consecutive 1s
        STATE_5,    // 5 consecutive 1s (potential discard)
        STATE_6,    // 6 consecutive 1s (flag)
        STATE_ERR   // 7+ consecutive 1s (error)
    } state_t;

    // Current and next state registers
    state_t current_state, next_state;

    // Output registers
    reg disc_reg, flag_reg, err_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_0;
            disc_reg <= 0;
            flag_reg <= 0;
            err_reg <= 0;
        end else begin
            current_state <= next_state;
            
            // Clear outputs after one cycle
            disc_reg <= 0;
            flag_reg <= 0;
            err_reg <= 0;
            
            // Set outputs based on next state transitions
            case (next_state)
                STATE_0: begin
                    if (current_state == STATE_5 && in == 0) disc_reg <= 1;
                    if (current_state == STATE_6 && in == 0) flag_reg <= 1;
                    if (current_state == STATE_ERR && in == 0) err_reg <= 1;
                end
                STATE_ERR: begin
                    if (current_state == STATE_6 && in == 1) err_reg <= 1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            STATE_0: next_state = in ? STATE_1 : STATE_0;
            STATE_1: next_state = in ? STATE_2 : STATE_0;
            STATE_2: next_state = in ? STATE_3 : STATE_0;
            STATE_3: next_state = in ? STATE_4 : STATE_0;
            STATE_4: next_state = in ? STATE_5 : STATE_0;
            STATE_5: next_state = in ? STATE_6 : STATE_0;
            STATE_6: next_state = in ? STATE_ERR : STATE_0;
            STATE_ERR: next_state = in ? STATE_ERR : STATE_0;
            default: next_state = STATE_0;
        endcase
    end

    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule