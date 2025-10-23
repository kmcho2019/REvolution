module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State definitions
    parameter S0 = 0;  // Initial state (0 consecutive 1s)
    parameter S1 = 1;  // 1 consecutive 1
    parameter S2 = 2;  // 2 consecutive 1s
    parameter S3 = 3;  // 3 consecutive 1s
    parameter S4 = 4;  // 4 consecutive 1s
    parameter S5 = 5;  // 5 consecutive 1s (discard detection)
    parameter S6 = 6;  // 6 consecutive 1s (flag detection)
    parameter SE = 7;  // Error state (7+ consecutive 1s)

    reg [2:0] current_state, next_state;
    reg disc_reg, flag_reg, err_reg;

    // State transition logic (combinational)
    always @(*) begin
        case (current_state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? SE : S0;
            SE: next_state = in ? SE : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic (combinational)
    always @(*) begin
        disc_reg = 0;
        flag_reg = 0;
        err_reg = 0;
        
        case (current_state)
            S5: disc_reg = ~in;  // Detect 0111110
            S6: flag_reg = ~in;  // Detect 01111110
            SE: err_reg = in;    // Detect 01111111...
        endcase
    end

    // State and output registers (sequential)
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            current_state <= next_state;
            // Register outputs to ensure they appear one cycle after condition
            disc <= disc_reg;
            flag <= flag_reg;
            err <= err_reg;
        end
    end

endmodule