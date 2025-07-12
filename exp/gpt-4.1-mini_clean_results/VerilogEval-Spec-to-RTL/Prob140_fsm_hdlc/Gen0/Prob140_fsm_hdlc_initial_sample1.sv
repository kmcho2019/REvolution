module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // States represent the count of consecutive ones: 0 to 6
    // 0: zero or last bit was zero
    // 1 to 6: consecutive ones count
    reg [2:0] state, next_state;

    always @(*) begin
        // Default outputs
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;

        case(state)
            3'd0: begin
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
                else begin
                    // 5 ones followed by zero: disc should be asserted on next cycle (current state)
                    next_state = 3'd0;
                end
            end
            3'd6: begin
                if (in == 1'b1) begin
                    // 7 or more ones detected: error asserted
                    next_state = 3'd6; // stay here (saturate)
                end else begin
                    // 6 ones followed by zero: flag should be asserted
                    next_state = 3'd0;
                end
            end
            default: begin
                next_state = 3'd0;
            end
        endcase

        // Outputs are based on the state and input (Moore FSM outputs depend only on current state)
        // But disc and flag are signaled on the cycle *after* the pattern is detected:
        // So outputs triggered in the cycle after the recognized pattern

        // To achieve this, outputs are asserted when the previous state+input combo indicated the pattern
        // Since outputs are purely Moore, we base output only on current state:
        // Use state to signal outputs:
        // disc: detected 5 ones followed by zero means disc output at next cycle in state 0 after transition from 5 ones + zero input
        // flag: detected 6 ones followed by zero means flag output at next cycle in state 0 after transition from 6 ones + zero input
        // err: detected 7 or more ones (state 6 and input 1), signal err now.

        // The easiest way is to encode output in states where we have already seen the pattern:

        // We can do the outputs in states after the transition:

        // So actually, disc and flag should be asserted in state 0 on the cycle after the input zero after 5 or 6 ones.

        // Let's add some output flags:

        // To do this, keep track of when disc or flag should be asserted next cycle.

    end

    // To implement the outputs that assert one cycle after the condition,
    // we can generate outputs based on state and input in the previous cycle.
    // Another way is to use the next state as indicator.

    // We add registers to hold output triggers:

    // For synchronous output, we define a register that captures whether disc or flag should be asserted next cycle

    reg disc_next, flag_next;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
            disc_next <= 1'b0;
            flag_next <= 1'b0;
        end else begin
            state <= next_state;
            disc <= disc_next;
            flag <= flag_next;

            // err is asserted immediately when 7 or more consecutive ones are detected (state 6 and in=1)
            err <= (state == 3'd6 && in == 1'b1);

            // Determine disc_next and flag_next for next cycle outputs

            // disc_next: set if previous state was 5 ones and input is zero
            disc_next <= (state == 3'd5 && in == 1'b0);

            // flag_next: set if previous state was 6 ones and input is zero
            flag_next <= (state == 3'd6 && in == 1'b0);
        end
    end

endmodule