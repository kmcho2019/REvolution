module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // States encoding
    typedef enum logic [3:0] {
        S0 = 4'd0, // no consecutive 1s
        S1 = 4'd1, // 1 consecutive 1
        S2 = 4'd2, // 2 consecutive 1s
        S3 = 4'd3, // 3 consecutive 1s
        S4 = 4'd4, // 4 consecutive 1s
        S5 = 4'd5, // 5 consecutive 1s
        S6 = 4'd6, // 6 consecutive 1s
        S7 = 4'd7  // error (7 or more ones)
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            S0: next_state = (in) ? S1 : S0;
            S1: next_state = (in) ? S2 : S0;
            S2: next_state = (in) ? S3 : S0;
            S3: next_state = (in) ? S4 : S0;
            S4: next_state = (in) ? S5 : S0;
            S5: next_state = (in) ? S6 : S0;
            S6: next_state = (in) ? S7 : S0;
            S7: next_state = (in) ? S7 : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic: outputs asserted for one cycle starting on the cycle after the pattern occurs.
    // Moore machine: outputs depend only on state.
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            state <= next_state;

            // Clear outputs by default
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;

            // Determine output based on current state and input for previous cycle
            // Because outputs are asserted one cycle after the condition,
            // outputs depend on the previous state and input transition.

            // So outputs are driven by current state (which is the next_state from previous cycle)
            // and the input of the previous cycle, but since we don't store previous input separately,
            // we encode outputs as follows:

            // The output conditions occur during transitions from the previous state with the previous input.

            // However, Moore output is based on state only; since we need to know if last input was 0 or 1,
            // we can handle outputs on the current state and input.

            // For the output that depends on transition from S5 with 0 input => disc
            // For the output that depends on transition from S6 with 0 input => flag
            // For the output that depends on state S7 => err

            // We'll store previous input to know the transition input.

            // To simplify, since we need to assert outputs after transition,
            // we save previous state and previous input and assert outputs based on that.

        end
    end

    // To implement outputs as per Moore machine:
    // Save previous state and previous input to determine outputs on current cycle
    reg state_d;
    reg [3:0] prev_state;
    reg prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_state <= S0;
            prev_in <= 1'b0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            prev_state <= state;
            prev_in <= in;

            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;

            // Check output conditions based on previous state and previous input

            // Condition 1: from S5 with input 0 => discard bit
            if (prev_state == S5 && prev_in == 1'b0) begin
                disc <= 1'b1;
            end

            // Condition 2: from S6 with input 0 => flag detected
            else if (prev_state == S6 && prev_in == 1'b0) begin
                flag <= 1'b1;
            end

            // Condition 3: current state S7 => error
            // err output should be asserted during S7 state
            if (state == S7) begin
                err <= 1'b1;
            end
        end
    end

endmodule