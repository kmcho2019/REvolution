module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // One-hot state encoding
    localparam [7:0]
        S0 = 8'b0000_0001, // 0 consecutive 1's
        S1 = 8'b0000_0010, // 1 consecutive 1
        S2 = 8'b0000_0100, // 2 consecutive 1's
        S3 = 8'b0000_1000, // 3 consecutive 1's
        S4 = 8'b0001_0000, // 4 consecutive 1's
        S5 = 8'b0010_0000, // 5 consecutive 1's
        S6 = 8'b0100_0000, // 6 consecutive 1's
        S7 = 8'b1000_0000; // 7 or more consecutive 1's (error)

    reg [7:0] state, next_state;

    // Combinational logic: next state logic only
    always @(*) begin
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
                else
                    next_state = S0; // input zero after 5 ones => disc discard zero bit
            end
            S6: begin
                if (in)
                    next_state = S7; // 7 ones => error
                else
                    next_state = S0; // input zero after 6 ones => flag detected
            end
            S7: begin
                if (in)
                    next_state = S7; // stay error
                else
                    next_state = S0; // clear error on zero input
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

    // Combinational logic: Moore outputs (depend on current state only)
    always @(*) begin
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;

        case (state)
            S5: begin
                // Disc bit occurs on transition from S5 to S0 when input=0,
                // but outputs depend on current state only.
                // To get disc output asserted exactly one cycle after detection,
                // outputs can be asserted in S5 only if next_state = S0 and input=0.
                // But Moore FSM disallows outputs depending on input.
                // So adjust by detecting disc in S5 only if next_state is S0.
                // But next_state depends on input, and output can't depend on input in Moore FSM.
                // Therefore, since output is state dependent only, output disc at S5 only when input=0.
                // We can't detect input here without breaking Moore FSM.

                // Trick: To be strictly Moore, outputs cannot depend on input.
                // Instead, define two separate states after S5: one for disc and one for continue counting.

                // But problem states to implement FSM as described.

                // To solve this, expand FSM states slightly:

                // But this is an optional optimization; the original solution asserted disc in next state.
                // For simplicity and matching the problem expectations,
                // assert disc in S5 regardless; but that would trigger on every S5 cycle, wrong.

                // Better to rely on next_state and input to define disc combinationally before registering.

                // But the problem mandates Moore FSM: outputs depend only on state.

                // Thus the given original code asserting disc in next_state combinational is accepted.

                // So here, no disc asserted.

                // Accept no disc assertion here, keep disc in sequential block as in original.

                // Alternative approach:

                // Introduce a registered signal to capture that input was zero in S5 on previous cycle.
            end
            S6: begin
                // flag asserted on transition from S6 to S0 with input=0 (01111110)
                // same Moore output timing problem as disc.
                // So same approach as disc.

                // No flag asserted here.

            end
            S7: begin
                // Err asserted throughout error state (S7)
                err = 1'b1;
            end
            default: begin
                // no outputs asserted
            end
        endcase
    end

    // To fix disc and flag outputs while maintaining Moore FSM style,
    // implement an output register logic that asserts outputs on the clock cycle AFTER the transition occurs.
    // To do this, add a small output logic FSM or register intermediate signals.

    // Implement a "condition_detected" signal that captures the transitions and raises outputs on next cycle.

    reg disc_r, flag_r;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
            disc_r <= 1'b0;
            flag_r <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs registered from prior cycle's conditions:
            disc  <= disc_r;
            flag  <= flag_r;
            err   <= (next_state == S7);

            // Detect disc: transition from S5 with input=0 => next_state == S0
            disc_r <= (state == S5) && (next_state == S0);

            // Detect flag: transition from S6 with input=0 => next_state == S0
            flag_r <= (state == S6) && (next_state == S0);
        end
    end

endmodule