module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Define FSM states encoding count of consecutive ones (0 to 7+)
    typedef enum reg [3:0] {
        S_0  = 4'd0,  // no consecutive ones
        S_1  = 4'd1,
        S_2  = 4'd2,
        S_3  = 4'd3,
        S_4  = 4'd4,
        S_5  = 4'd5,
        S_6  = 4'd6,
        S_7p = 4'd7   // 7 or more consecutive ones
    } state_t;

    reg [3:0] state, next_state;

    // Next-state logic (combinational)
    always @(*) begin
        case (state)
            S_0:  next_state = (in) ? S_1  : S_0;
            S_1:  next_state = (in) ? S_2  : S_0;
            S_2:  next_state = (in) ? S_3  : S_0;
            S_3:  next_state = (in) ? S_4  : S_0;
            S_4:  next_state = (in) ? S_5  : S_0;
            S_5:  next_state = (in) ? S_6  : S_0;
            S_6:  next_state = (in) ? S_7p : S_0;
            S_7p: next_state = (in) ? S_7p : S_0;
            default: next_state = S_0;
        endcase
    end

    // State register and output logic (Moore outputs)
    always @(posedge clk) begin
        if (reset) begin
            state <= S_0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs asserted for one cycle after condition:
            // disc: when previous state was S_5 and in == 0 (transition to S_0)
            // flag: when previous state was S_6 and in == 0 (transition to S_0)
            // err:  when current state is S_7p

            // Because outputs are Moore type, they depend on current state only.
            // To assert outputs one cycle later, use the state before update,
            // so assign outputs based on the next state of previous cycle.

            // This is achieved by asserting outputs based on next_state from previous cycle.
            // Since outputs must be synchronous and asserted for one cycle after detection,
            // outputs reflect conditions of the previous cycle's inputs and state.

            disc <= (state == S_5) && (in == 1'b0);
            flag <= (state == S_6) && (in == 1'b0);
            err  <= (state == S_7p);
        end
    end

endmodule