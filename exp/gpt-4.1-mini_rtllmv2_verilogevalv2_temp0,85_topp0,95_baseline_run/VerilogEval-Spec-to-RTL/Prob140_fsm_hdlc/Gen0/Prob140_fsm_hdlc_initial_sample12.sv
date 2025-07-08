module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding: count of consecutive 1s seen since last zero, capped at 6.
    // state = 0..6; 6 means 6 or more 1s.
    reg [2:0] state, next_state;

    // Moore outputs depend on state and input combination from previous cycle.
    // To generate outputs one cycle later, we use registered signals based on previous state's transitions.

    // On each clock, state <= next_state
    // output on cycle after condition met.

    always @(*) begin
        // Default outputs: no signal
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;

        // Determine outputs based on current state and current input
        // The outputs are associated with the *previous* input condition which caused the transition
        // So outputs are based on previous state and previous input.
        // Since this is combinational, we describe outputs for the current state and input combination.
        // But outputs must be registered, so they appear on next cycle.

        // To handle this cleanly, outputs are set according to the previous state and input.
        // However, since this is a Moore FSM and outputs only depend on states, and outputs are asserted for one cycle,
        // we implement outputs based on the next_state transition logic from current state and input.

        // Therefore, output is asserted based on the current state and current input pattern that triggers the condition.

        // So outputs correspond to current inputs and current state: output signals asserted on next clock cycle.

        case (state)
            3'd5: begin
                // If in state 5 (five consecutive ones), and input=0 => disc = 1 next cycle
                if (in == 1'b0)
                    disc = 1'b1;
            end

            3'd6: begin
                if (in == 1'b0) begin
                    // After 6 consecutive ones, a zero means flag detected next cycle
                    flag = 1'b1;
                end else begin
                    // If still one, means 7 or more consecutive ones -> error next cycle
                    err = 1'b1;
                end
            end

            default: begin
                // no outputs for other states
            end
        endcase
    end

    // Next state logic
    always @(*) begin
        case (state)
            3'd0: begin
                // Previous bit was zero or reset state
                if (in == 1'b1)
                    next_state = 3'd1;
                else
                    next_state = 3'd0;
            end
            3'd1: begin
                if (in == 1'b1)
                    next_state = 3'd2;
                else
                    next_state = 3'd0;
            end
            3'd2: begin
                if (in == 1'b1)
                    next_state = 3'd3;
                else
                    next_state = 3'd0;
            end
            3'd3: begin
                if (in == 1'b1)
                    next_state = 3'd4;
                else
                    next_state = 3'd0;
            end
            3'd4: begin
                if (in == 1'b1)
                    next_state = 3'd5;
                else
                    next_state = 3'd0;
            end
            3'd5: begin
                if (in == 1'b1)
                    next_state = 3'd6;
                else
                    next_state = 3'd0;
            end
            3'd6: begin
                if (in == 1'b1)
                    next_state = 3'd6; // stay in error condition state (7+ ones)
                else
                    next_state = 3'd0;
            end
            default: next_state = 3'd0;
        endcase
    end

    // State update on positive edge of clock with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;
        end else begin
            state <= next_state;
        end
    end

endmodule