module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

    // States represent number of consecutive ones seen after last zero:
    // 0: last input was 0 or reset
    // 1: one consecutive 1
    // ...
    // 6: six consecutive 1s
    // 7: seven or more consecutive 1s (error state)
    reg [3:0] state, next_state;

    // State encoding (just use numbers 0 to 7)
    localparam S0 = 0;
    localparam S1 = 1;
    localparam S2 = 2;
    localparam S3 = 3;
    localparam S4 = 4;
    localparam S5 = 5;
    localparam S6 = 6;
    localparam S7 = 7;

    // Next state logic
    always @(*) begin
        case(state)
            S0: begin
                if (in) next_state = S1;
                else    next_state = S0;
            end
            S1: begin
                if (in) next_state = S2;
                else    next_state = S0;
            end
            S2: begin
                if (in) next_state = S3;
                else    next_state = S0;
            end
            S3: begin
                if (in) next_state = S4;
                else    next_state = S0;
            end
            S4: begin
                if (in) next_state = S5;
                else    next_state = S0;
            end
            S5: begin
                if (in) next_state = S6;
                else    next_state = S0;
            end
            S6: begin
                if (in) next_state = S7; // error if 7 or more ones
                else    next_state = S0;
            end
            S7: begin
                // stay in error state if more ones, reset count if zero
                if (in) next_state = S7;
                else    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // Sequential logic and output logic (Moore outputs depend on state)
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err  <= 0;
        end else begin
            state <= next_state;

            // Default outputs
            disc <= 0;
            flag <= 0;
            err  <= 0;

            // Assert outputs based on current state and current input to detect patterns
            // Because outputs are Moore type, outputs depend only on the state *before* transition,
            // but the problem states the output signal should be asserted beginning the clock cycle
            // after the condition occurs, so we check current state and input that caused transition.

            case(state)
                S5: begin
                    // we have seen 5 consecutive ones, so previous bits are 011111
                    // If next input is 0, disc must be asserted next cycle.
                    // But we can't lookahead next input here; outputs must depend on state only.
                    // The problem states outputs should be asserted one cycle after condition,
                    // so we use state and input now to set outputs next cycle.
                    // To implement this, we can use the current state and input to generate outputs on next cycle.
                    // So we actually need a registered input, or output logic based on previous state and input.
                    // To simplify, we add a 1 cycle delayed input register and implement outputs combinationally based on previous state and input.

                    // However, since the spec states synchronous reset and outputs asserted one cycle after condition,
                    // a common approach is to do the outputs based on previous state's transition conditions,
                    // so we will register the input and do outputs based on previous state and delayed input.
                end
                S6: begin
                    // when in S6 and input=0, flag detected (01111110)
                    // when in S6 and input=1, go to error state next cycle
                end
                S7: begin
                    // error detected (7 or more ones)
                end
            endcase
        end
    end

    // To implement Moore outputs one cycle after condition, we register input and do output logic from previous state and input.
    // Add delayed input register.
    reg in_d;

    always @(posedge clk) begin
        if (reset) in_d <= 0;
        else       in_d <= in;
    end

    // Use a combinational always block to generate outputs based on previous state and input_d
    // State in the sequential block is "current" state; so outputs are from previous state and input_d.
    reg disc_nxt, flag_nxt, err_nxt;
    reg [3:0] state_d;

    always @(posedge clk) begin
        if(reset) begin
            state_d <= S0;
        end else begin
            state_d <= state;
        end
    end

    always @(*) begin
        disc_nxt = 0;
        flag_nxt = 0;
        err_nxt  = 0;

        case(state_d)
            S5: begin
                // If input_d == 0 after 5 ones => discard bit
                if (~in_d) disc_nxt = 1;
            end
            S6: begin
                // If input_d == 0 after 6 ones => flag detected
                if (~in_d) flag_nxt = 1;
                else err_nxt = 1; // if input_d == 1 after 6 ones, error detected next cycle
            end
            S7: begin
                // error detected at 7 or more ones
                err_nxt = 1;
            end
            default: begin
                disc_nxt = 0;
                flag_nxt = 0;
                err_nxt  = 0;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err  <= 0;
        end else begin
            disc <= disc_nxt;
            flag <= flag_nxt;
            err  <= err_nxt;
        end
    end

endmodule