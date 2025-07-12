module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // One-hot encoded states
    parameter S0 = 7'b0000001;  // Initial state (0 consecutive 1s)
    parameter S1 = 7'b0000010;  // 1 consecutive 1
    parameter S2 = 7'b0000100;  // 2 consecutive 1s
    parameter S3 = 7'b0001000;  // 3 consecutive 1s
    parameter S4 = 7'b0010000;  // 4 consecutive 1s
    parameter S5 = 7'b0100000;  // 5 consecutive 1s
    parameter S6 = 7'b1000000;  // 6+ consecutive 1s

    reg [6:0] state, next_state;
    reg disc_reg, flag_reg, err_reg;

    // State transition logic
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S6 : S0;
            default: next_state = S0;
        endcase
    end

    // State register and output registers
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc_reg <= 0;
            flag_reg <= 0;
            err_reg <= 0;
        end else begin
            state <= next_state;
            
            // Set outputs for next cycle
            disc_reg <= (state == S5) && !in;
            flag_reg <= (state == S6) && !in;
            err_reg <= (state == S6) && in;
        end
    end

    // Continuous assignments for outputs
    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule