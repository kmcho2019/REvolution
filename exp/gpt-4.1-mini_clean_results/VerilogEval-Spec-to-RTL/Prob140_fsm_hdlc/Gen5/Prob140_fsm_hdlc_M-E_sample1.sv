module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding for counts of consecutive ones
    typedef enum logic [3:0] {
        S0 = 4'd0,  // zero consecutive ones
        S1 = 4'd1,  // 1 consecutive one
        S2 = 4'd2,  // 2 consecutive ones
        S3 = 4'd3,  // 3 consecutive ones
        S4 = 4'd4,  // 4 consecutive ones
        S5 = 4'd5,  // 5 consecutive ones
        S6 = 4'd6,  // 6 consecutive ones
        S7 = 4'd7   // error: 7 or more consecutive ones
    } state_t;

    state_t state, state_next;

    // State transition logic (Moore FSM)
    always @(*) begin
        case (state)
            S0: state_next = in ? S1 : S0;

            S1: state_next = in ? S2 : S0;

            S2: state_next = in ? S3 : S0;

            S3: state_next = in ? S4 : S0;

            S4: state_next = in ? S5 : S0;

            S5: state_next = in ? S6 : S0;  // disc occurs on input=0 from S5, next state S0

            S6: state_next = in ? S7 : S0;  // flag occurs on input=0 from S6, next state S0

            S7: state_next = in ? S7 : S0;  // err asserted until input=0 resets count

            default: state_next = S0;
        endcase
    end

    // Outputs combinationally derived from current state (Moore outputs)
    // Outputs are asserted exactly one cycle after detection because FSM outputs depend solely on present state.
    always @(*) begin
        // Default outputs off
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;

        case (state)
            // disc is asserted when previous input sequence was exactly 5 ones followed by 0,
            // i.e., when FSM just entered S0 from S5 via input=0, so outputs appear in S0 after disc condition.
            // To do this, detect when FSM is in S0 and previous state was S5 with input=0.
            // But Moore FSM cannot detect "previous" state here, so we encode output in states that reflect the condition after transition.
            // So we define disc output asserted only in S0 when previous transition was from S5 with input=0.
            // To achieve this, introduce an internal signal or implement outputs based on present state and input.

            // To keep Moore FSM logic pure, we can encode disc and flag outputs directly in states S0 and check previous state in sequential logic.
            // However, since only state is stored, alternative is to produce disc and flag output *only* in the states reached after disc or flag detection (i.e., S0 immediately after input=0 from S5 or S6).

            // To accomplish this, store previous state and input to decode outputs in current cycle.

            // Implemented below.

            default: ;
        endcase
    end

    // Store previous state and input to generate outputs in Moore manner
    reg prev_disc, prev_flag, prev_err;
    reg [3:0] prev_state;
    reg prev_in;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            prev_state <= S0;
            prev_in <= 1'b0;

            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            state <= state_next;

            // Outputs asserted for one cycle on the cycle *after* detection:
            // Disc: when prev_state = S5 and prev_in = 0 and current state = S0
            disc <= (prev_state == S5) && (prev_in == 1'b0) && (state_next == S0);

            // Flag: when prev_state = S6 and prev_in = 0 and current state = S0
            flag <= (prev_state == S6) && (prev_in == 1'b0) && (state_next == S0);

            // Err: when in state S7 (error state)
            // Err asserted continuously in error state as per spec.
            err <= (state_next == S7);

            prev_state <= state;
            prev_in <= in;
        end
    end

endmodule