module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding: number of consecutive 1s seen after last zero
    typedef enum logic [3:0] {
        S0 = 4'd0,  // zero consecutive 1s
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        S7 = 4'd7    // error state: 7 or more consecutive 1s
    } state_t;

    state_t state, next_state;

    // Next outputs - Moore outputs depend on next state after input is sampled
    logic next_disc, next_flag, next_err;

    always @(*) begin
        // Default next state is current state
        next_state = state;

        // Default outputs de-asserted
        next_disc = 1'b0;
        next_flag = 1'b0;
        next_err = 1'b0;

        case (state)
            S0: begin
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (in)
                    next_state = S2;
                else
                    next_state = S0;
            end
            S2: begin
                if (in)
                    next_state = S3;
                else
                    next_state = S0;
            end
            S3: begin
                if (in)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                if (in)
                    next_state = S5;
                else
                    next_state = S0;
            end
            S5: begin
                if (in) begin
                    next_state = S6;
                    // Receiving 1 after 5 ones, continue counting, no output yet
                end else begin
                    // Receiving 0 after 5 ones = zero-stuff bit to discard
                    next_state = S0;
                    next_disc = 1'b1;
                end
            end
            S6: begin
                if (in) begin
                    next_state = S7;
                    // 7 consecutive 1s => error next cycle
                end else begin
                    // Receiving 0 after 6 ones = flag boundary detected
                    next_state = S0;
                    next_flag = 1'b1;
                end
            end
            S7: begin
                // Stay in error state while input remains 1 or 0
                next_state = (in) ? S7 : S0;
                next_err = 1'b1;
            end
            default: next_state = S0;
        endcase
    end

    // State and output registers updated synchronously
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            state <= next_state;
            disc <= next_disc;
            flag <= next_flag;
            err <= next_err;
        end
    end

endmodule