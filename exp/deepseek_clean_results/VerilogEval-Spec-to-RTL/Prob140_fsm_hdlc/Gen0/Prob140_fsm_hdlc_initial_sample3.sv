module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State encoding: number of consecutive 1s seen (0-7)
    reg [2:0] state, next_state;
    reg next_disc, next_flag, next_err;

    // Output registers
    reg reg_disc, reg_flag, reg_err;

    // State definitions
    localparam S0 = 3'd0;  // 0 consecutive 1s
    localparam S1 = 3'd1;  // 1 consecutive 1
    localparam S2 = 3'd2;  // 2 consecutive 1s
    localparam S3 = 3'd3;  // 3 consecutive 1s
    localparam S4 = 3'd4;  // 4 consecutive 1s
    localparam S5 = 3'd5;  // 5 consecutive 1s
    localparam S6 = 3'd6;  // 6 consecutive 1s
    localparam S7 = 3'd7;  // 7+ consecutive 1s (error state)

    // Next state and output logic
    always @(*) begin
        // Default assignments
        next_state = state;
        next_disc = 1'b0;
        next_flag = 1'b0;
        next_err = 1'b0;

        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: begin
                if (in) begin
                    next_state = S6;
                end else begin
                    next_state = S0;
                    next_disc = 1'b1;  // 0111110 pattern detected
                end
            end
            S6: begin
                if (in) begin
                    next_state = S7;
                end else begin
                    next_state = S0;
                    next_flag = 1'b1;  // 01111110 pattern detected
                end
            end
            S7: begin
                if (in) begin
                    next_state = S7;
                    next_err = 1'b1;   // 7+ 1s detected
                end else begin
                    next_state = S0;
                end
            end
            default: next_state = S0;
        endcase
    end

    // State and output registers
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            reg_disc <= 1'b0;
            reg_flag <= 1'b0;
            reg_err <= 1'b0;
        end else begin
            state <= next_state;
            reg_disc <= next_disc;
            reg_flag <= next_flag;
            reg_err <= next_err;
        end
    end

    // Output assignments
    assign disc = reg_disc;
    assign flag = reg_flag;
    assign err = reg_err;

endmodule