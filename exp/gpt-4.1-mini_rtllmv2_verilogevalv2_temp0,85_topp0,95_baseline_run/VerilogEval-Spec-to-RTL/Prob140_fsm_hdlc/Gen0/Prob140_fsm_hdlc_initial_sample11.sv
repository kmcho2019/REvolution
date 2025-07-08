module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding: counts of consecutive ones after a zero input
    // 0: last bit was zero or initial state
    // 1..6: count of consecutive ones
    // 7: error state (7 or more consecutive ones)
    reg [3:0] state, next_state;

    // Moore outputs depend on current state and current input (only transitions)
    // Since outputs are Moore, outputs depend on current state only,
    // but in this problem, outputs should be asserted the cycle AFTER the sequence detection.
    // So to implement that, we must latch the outputs based on previous state and current input:
    // We'll use the state and input to generate the next outputs (to be registered next cycle).

    // To implement Moore outputs, outputs depend only on current state.
    // So we encode outputs in the next_state logic:
    // We will generate outputs as registers updated each clock cycle.
    // The condition for outputs are based on transitions from previous cycle:
    // So we can generate outputs from the current state and current input.

    // To handle this, we will:
    // - compute next_state based on current state and input
    // - outputs (disc, flag, err) depend on the current state and input, but outputs are registered and come out on next clock cycle.
    // So outputs are assigned based on previous cycle's next_state and input.

    reg disc_next, flag_next, err_next;

    always @(*) begin
        // default next state is zero
        next_state = 0;
        disc_next = 0;
        flag_next = 0;
        err_next = 0;

        case(state)
            0: begin
                if (in == 1)
                    next_state = 1;
                else
                    next_state = 0;
                // no outputs on zero state
            end
            1: begin
                if (in == 1)
                    next_state = 2;
                else
                    next_state = 0;
            end
            2: begin
                if (in == 1)
                    next_state = 3;
                else
                    next_state = 0;
            end
            3: begin
                if (in == 1)
                    next_state = 4;
                else
                    next_state = 0;
            end
            4: begin
                if (in == 1)
                    next_state = 5;
                else
                    next_state = 0;
            end
            5: begin
                if (in == 1)
                    next_state = 6;
                else begin
                    // input zero after 5 ones => bit-stuff zero detected to discard
                    next_state = 0;
                    disc_next = 1;
                end
            end
            6: begin
                if (in == 1) begin
                    // 7 consecutive ones => error
                    next_state = 7;
                    err_next = 1;
                end else begin
                    // input zero after 6 ones => flag detected
                    next_state = 0;
                    flag_next = 1;
                end
            end
            7: begin
                // error state, remain in error if input is 1, or reset if input is 0
                err_next = 1;
                if (in == 1)
                    next_state = 7;
                else
                    next_state = 0;
            end
            default: begin
                next_state = 0;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            state <= next_state;
            disc <= disc_next;
            flag <= flag_next;
            err <= err_next;
        end
    end

endmodule