module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    typedef enum reg [3:0] {
        S0 = 4'd0,  // 0 consecutive ones
        S1 = 4'd1,  // 1 consecutive one
        S2 = 4'd2,  // 2 consecutive ones
        S3 = 4'd3,  // 3 consecutive ones
        S4 = 4'd4,  // 4 consecutive ones
        S5 = 4'd5,  // 5 consecutive ones
        S6 = 4'd6,  // 6 consecutive ones
        S7P = 4'd7  // 7 or more consecutive ones (error state)
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            S0:  next_state = in ? S1 : S0;
            S1:  next_state = in ? S2 : S0;
            S2:  next_state = in ? S3 : S0;
            S3:  next_state = in ? S4 : S0;
            S4:  next_state = in ? S5 : S0;
            S5:  next_state = in ? S6 : S0;
            S6:  next_state = in ? S7P : S0;
            S7P: next_state = in ? S7P : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic (Moore FSM outputs depend only on current state)
    // Outputs are asserted for one cycle starting the clock cycle after the pattern completes
    // To meet this, outputs reflect the previous state's signals.
    reg disc_d, flag_d, err_d;
    always @(*) begin
        // Default no output
        disc_d = 1'b0;
        flag_d = 1'b0;
        err_d  = 1'b0;
        case (state)
            // disc asserted when previous count=5 and in=0 detected, so on state S0 from S5
            // But as outputs depend only on current state and not inputs, we rely on transitions:
            // Because outputs assert one cycle after event, we set outputs based on previous state and input transition.
            // Since outputs only use current state, we map them as follows:
            // From S5 state: if next input is 0, then disc will be asserted next cycle => disc asserted in S0 state only if previous was S5 and input=0
            // To handle this simply, we use state to track count of ones, and set outputs in next states:
            // So outputs depend on previous state and input: We'll implement registers to delay outputs properly.

            // Instead, we assign outputs in the sequential block after transition, using stored previous state and input.
            default: ;
        endcase
    end

    reg state_d, in_d; // stored previous state and input for output logic

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
            state_d <= S0;
            in_d <= 1'b0;
        end else begin
            state <= next_state;
            state_d <= state;
            in_d <= in;

            // Outputs assert based on previous state and input value (one cycle after event)
            // disc = previous state S5 and in=0 => disc cycle after detecting '0111110'
            // flag = previous state S6 and in=0 => '01111110' flag
            // err  = previous state S6 or S7P and in=1 => '01111111...' error
            disc <= (state_d == S5) && (in_d == 1'b0);
            flag <= (state_d == S6) && (in_d == 1'b0);
            err  <= ((state_d == S6) || (state_d == S7P)) && (in_d == 1'b1);
        end
    end

endmodule