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
        S0, S1, S2, S3, S4, S5, S6, S7
    } state_t;

    state_t current_state, next_state;
    reg disc_reg, flag_reg, err_reg;

    // State transition logic
    always_comb begin
        case (current_state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic (registered)
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            disc_reg <= 0;
            flag_reg <= 0;
            err_reg <= 0;
        end else begin
            current_state <= next_state;
            
            // Reset outputs
            disc_reg <= 0;
            flag_reg <= 0;
            err_reg <= 0;
            
            // Set outputs based on current state and input
            case (current_state)
                S5: if (!in) disc_reg <= 1;
                S6: if (!in) flag_reg <= 1;
                S7: begin
                    if (!in) err_reg <= 1;
                    else err_reg <= 1;
                end
                default: ; // No outputs for other states
            endcase
        end
    end

    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule