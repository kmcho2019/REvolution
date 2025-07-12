module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding with parameters, 3 bits sufficient for 8 states
    parameter S0 = 3'd0;  // 0 consecutive ones
    parameter S1 = 3'd1;  // 1 consecutive one
    parameter S2 = 3'd2;
    parameter S3 = 3'd3;
    parameter S4 = 3'd4;
    parameter S5 = 3'd5;
    parameter S6 = 3'd6;
    parameter S7 = 3'd7;  // error state: 7 or more consecutive ones

    reg [2:0] state, next_state;
    reg next_disc, next_flag, next_err;

    // Combinational next state and outputs logic (Moore FSM)
    always @(*) begin
        // Defaults
        next_state = state;
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
                if (in)
                    next_state = S6;
                else begin
                    next_state = S0;
                    next_disc = 1'b1; // discard bit after five consecutive 1s + zero
                end
            end
            S6: begin
                if (in) begin
                    next_state = S7; // error state on 7 consecutive ones
                end else begin
                    next_state = S0;
                    next_flag = 1'b1; // flag detected after six consecutive ones + zero
                end
            end
            S7: begin
                // Stay in error state if input remains 1
                // Reset to S0 if zero is received
                if (in)
                    next_state = S7;
                else
                    next_state = S0;
                next_err = 1'b1;
            end
            default: next_state = S0;
        endcase
    end

    // Sequential state and output update on posedge clk, synchronous active high reset
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