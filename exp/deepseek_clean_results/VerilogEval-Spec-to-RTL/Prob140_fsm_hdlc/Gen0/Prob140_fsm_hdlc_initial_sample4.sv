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
        S0,  // Initial state or after 0
        S1,   // 1
        S2,   // 11
        S3,   // 111
        S4,   // 1111
        S5,   // 11111
        S6,   // 111111 (flag)
        S7    // 1111111+ (error)
    } state_t;

    // State registers
    state_t current_state, next_state;

    // Output registers
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

    // Output logic (Moore style - depends only on current state)
    always_comb begin
        disc_reg = 0;
        flag_reg = 0;
        err_reg = 0;

        case (current_state)
            S5: disc_reg = in;  // After 5 1s, if next is 1, discard
            S6: flag_reg = ~in;  // After 6 1s, if next is 0, flag
            S7: err_reg = 1;     // 7 or more 1s is error
            default: begin
                disc_reg = 0;
                flag_reg = 0;
                err_reg = 0;
            end
        endcase
    end

    // State update and output registration
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            current_state <= next_state;
            disc <= disc_reg;
            flag <= flag_reg;
            err <= err_reg;
        end
    end

endmodule