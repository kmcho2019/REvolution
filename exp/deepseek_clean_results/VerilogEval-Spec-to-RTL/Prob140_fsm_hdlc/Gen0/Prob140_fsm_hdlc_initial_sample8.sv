module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // Define states for the Moore FSM
    typedef enum logic [2:0] {
        S_RESET,    // Initial state (after reset or 0)
        S_1,        // 1 consecutive 1
        S_2,        // 2 consecutive 1s
        S_3,        // 3 consecutive 1s
        S_4,        // 4 consecutive 1s
        S_5,        // 5 consecutive 1s
        S_6,        // 6 consecutive 1s
        S_ERR       // 7+ consecutive 1s (error)
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always_comb begin
        case (current_state)
            S_RESET: next_state = in ? S_1 : S_RESET;
            S_1:     next_state = in ? S_2 : S_RESET;
            S_2:     next_state = in ? S_3 : S_RESET;
            S_3:     next_state = in ? S_4 : S_RESET;
            S_4:     next_state = in ? S_5 : S_RESET;
            S_5:     next_state = in ? S_6 : S_RESET;
            S_6:     next_state = in ? S_ERR : S_RESET;
            S_ERR:   next_state = in ? S_ERR : S_RESET;
            default: next_state = S_RESET;
        endcase
    end

    // State register
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= S_RESET;
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic (registered to ensure one-cycle duration)
    reg disc_reg, flag_reg, err_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            disc_reg <= 0;
            flag_reg <= 0;
            err_reg <= 0;
        end else begin
            // Detect discard case (0111110)
            disc_reg <= (current_state == S_5) && !in;
            
            // Detect flag case (01111110)
            flag_reg <= (current_state == S_6) && !in;
            
            // Detect error case (7+ 1s)
            err_reg <= (current_state == S_ERR);
        end
    end

    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule