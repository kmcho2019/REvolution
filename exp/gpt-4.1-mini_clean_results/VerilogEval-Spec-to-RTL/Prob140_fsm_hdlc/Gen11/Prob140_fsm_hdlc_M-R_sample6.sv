module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Define FSM states as number of consecutive ones counted (0 to 7+)
    typedef enum reg [3:0] {
        S0 = 4'd0,  // 0 consecutive ones
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        S7 = 4'd7  // 7 or more consecutive ones (error)
    } state_t;

    state_t state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            S0: next_state = (in) ? S1 : S0;
            S1: next_state = (in) ? S2 : S0;
            S2: next_state = (in) ? S3 : S0;
            S3: next_state = (in) ? S4 : S0;
            S4: next_state = (in) ? S5 : S0;
            S5: next_state = (in) ? S6 : S0;
            S6: next_state = (in) ? S7 : S0;
            S7: next_state = (in) ? S7 : S0;  // Stay in error state if input still 1
            default: next_state = S0;
        endcase
    end

    // Output logic (Moore): outputs depend on current state
    // Outputs are asserted one cycle after the sequence is detected, so:
    // disc = detected "0111110" => current state S5 + next input 0 (means detected at previous cycle)
    // Since outputs are Moore, we assign outputs based on current state and input at previous cycle, effectively in the next cycle outputs fire.
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs asserted one cycle after detection:
            disc <= (state == S5) && (in == 1'b0);
            flag <= (state == S6) && (in == 1'b0);
            err  <= (state == S7) && (in == 1'b1);
        end
    end

endmodule