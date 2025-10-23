module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding representing count of consecutive ones:
    // S0: 0 consecutive ones
    // S1: 1 consecutive one
    // ...
    // S6: 6 consecutive ones
    // S7: error state (7 or more consecutive ones)
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

    // Compute next state logic combinationally
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;  // disc detected when in=0 after S5 (so on output)
            S6: next_state = in ? S7 : S0;  // flag detected when in=0 after S6
            S7: next_state = in ? S7 : S0;  // remain error until a zero resets
            default: next_state = S0;
        endcase
    end

    // State update and outputs: synchronous logic with reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Moore outputs based on current state before transition:
            // Outputs asserted for one cycle starting on clock cycle after detection
            // => outputs depend on previous state and current input

            // When disc condition occurs:
            // When previous state is S5 and current input is 0, disc asserted next cycle
            disc <= (state == S5) && (in == 1'b0);

            // When flag condition occurs:
            // When previous state is S6 and current input is 0, flag asserted next cycle
            flag <= (state == S6) && (in == 1'b0);

            // When error condition occurs:
            // When state is S7 (7 or more consecutive ones)
            err <= (state == S7);
        end
    end

endmodule