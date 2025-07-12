module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Define states encoding the count of consecutive 1s:
    // S0 = no consecutive ones (last bit 0)
    // S1 = 1 consecutive one
    // ...
    // S6 = 6 consecutive ones
    // S7 = 7 or more consecutive ones (error state)
    typedef enum logic [3:0] {
        S0 = 4'd0,
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        S7 = 4'd7
    } state_t;

    state_t state, next_state;

    // Combinational next state logic
    always @(*) begin
        case(state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0; // 7 or more ones => error state
            S7: next_state = in ? S7 : S0; // stay in error until reset or zero
            default: next_state = S0;
        endcase
    end

    // Output logic (Moore machine): outputs depend only on the current state
    // According to the problem, outputs are asserted one clock cycle after detection.
    // The detection conditions relate to the previous input sequence, so outputs
    // reflect what was detected in the previous cycle.
    //
    // Since the FSM is Moore, outputs are function of current state (which represents
    // the count of previous consecutive ones before the current input):
    //
    // We want to assert:
    // disc = when a zero follows exactly 5 ones (0111110)
    // flag = when a zero follows exactly 6 ones (01111110)
    // err  = when seven or more ones occur consecutively (01111111...)
    //
    // But outputs asserted in the cycle after the condition.
    //
    // To produce output in the cycle after detection, we assign outputs in the clocked block
    // based on previous state and current input.

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            // State update
            state <= next_state;

            // Outputs: check previous state and current input
            // disc: previous state S5 and current input zero -> detected 0111110
            // flag: previous state S6 and current input zero -> detected 01111110
            // err:  current state S7 -> seven or more ones
            disc <= (state == S5) && (in == 1'b0);
            flag <= (state == S6) && (in == 1'b0);
            err  <= (next_state == S7);
        end
    end

endmodule