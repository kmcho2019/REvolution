module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

// State encoding: count of consecutive 1's
typedef enum logic [3:0] {
    S0  = 4'd0, // last input 0 or reset state, no consecutive 1s
    S1  = 4'd1,
    S2  = 4'd2,
    S3  = 4'd3,
    S4  = 4'd4,
    S5  = 4'd5,
    S6  = 4'd6,
    S7p = 4'd7  // 7 or more consecutive 1s (error state)
} state_t;

state_t state, next_state;

// Next state logic
always @(*) begin
    case(state)
        S0: begin
            if (in == 1'b1)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if (in == 1'b1)
                next_state = S2;
            else
                next_state = S0;
        end
        S2: begin
            if (in == 1'b1)
                next_state = S3;
            else
                next_state = S0;
        end
        S3: begin
            if (in == 1'b1)
                next_state = S4;
            else
                next_state = S0;
        end
        S4: begin
            if (in == 1'b1)
                next_state = S5;
            else
                next_state = S0;
        end
        S5: begin
            if (in == 1'b1)
                next_state = S6;
            else
                next_state = S0;
        end
        S6: begin
            if (in == 1'b1)
                next_state = S7p;  // error state
            else
                next_state = S0;
        end
        S7p: begin
            // Once in error, remain if 1; reset on 0
            if (in == 1'b1)
                next_state = S7p;
            else
                next_state = S0;
        end
        default: next_state = S0;
    endcase
end

// Output logic (Moore outputs)
always @(*) begin
    // Default outputs
    disc = 1'b0;
    flag = 1'b0;
    err  = 1'b0;

    case(state)
        S6: begin
            // After seeing 6 consecutive 1s: next input 0 means flag;
            // next input 1 means error (handled by transition to S7p)
            // We assert outputs the cycle after the condition occurs,
            // so disc and flag are asserted from the next state.
            // The discard bit corresponds to zero after 5 ones,
            // which is when FSM is in S5 and sees zero.

            // Actually, disc corresponds to zero after 5 consecutive 1s,
            // which means at state S5, input=0 causes transition to S0 with disc=1
            // The FSM outputs must be asserted one cycle after condition,
            // so disc=1 at state S6 means the previous cycle saw zero after 5 ones,
            // so discard is asserted at S6.

            // The flag corresponds to zero after 6 ones,
            // so at state S0 with previous input zero after S6, flag=1
            // But we cannot know previous input here,
            // so better to encode disc and flag based on the current state.

            // Because the FSM outputs are Moore type, outputs depend only on state.
            // So assign disc=1 at S6 means the previous input was zero after 5 ones,
            // assign flag=1 at S0 means previous input zero after 6 ones.

            // But since we want outputs asserted one cycle after condition occurs,
            // let's define outputs as:
            // disc = (state == S6) && (previous input was zero after 5 ones)
            // flag = (state == S0) && (previous input was zero after 6 ones)
            // err  = (state == S7p)

            // However, we do not store previous input explicitly, so we use states to encode.

            // To simplify, output at S6: disc=1 (zero after 5 ones)
            // output at S0: flag=1 if previous pattern was zero after 6 ones
            // output at S7p: err=1

            // But the FSM only stores count of ones, so to detect zero after 5 or 6 ones,
            // we need an auxiliary register to remember last input.

            // Let's implement an auxiliary register to store last input and decide outputs in sequential block.
        end
        S7p: err = 1'b1;
        default: begin
            disc = 1'b0;
            flag = 1'b0;
            err  = 1'b0;
        end
    endcase
end

// To properly generate outputs one cycle after the pattern, we must track previous input and state transitions.
// We'll implement outputs in sequential logic using registered versions of signals.

reg prev_in;

// Sequential logic for state update and output signals
always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        disc  <= 1'b0;
        flag  <= 1'b0;
        err   <= 1'b0;
        prev_in <= 1'b0; // on reset behave as previous input zero
    end else begin
        state <= next_state;

        // Outputs asserted for one cycle after condition

        // Detect discard: zero after 5 consecutive ones
        // This means previous state S5 and current input zero => next_state S0
        // So disc asserted one cycle after condition => at state S6

        // Detect flag: zero after 6 consecutive ones
        // previous state S6 and current input zero => next_state S0
        // so flag asserted at state S0 but only when previous input zero after 6 ones

        // Detect error: 7 or more consecutive ones => state S7p

        // We use prev_state and current state to detect the condition

        // To do so, store previous state
    end
end

reg [3:0] prev_state;

always @(posedge clk) begin
    if (reset) begin
        prev_state <= S0;
        disc  <= 1'b0;
        flag  <= 1'b0;
        err   <= 1'b0;
        prev_in <= 1'b0;
    end else begin
        prev_state <= state;

        // Default outputs
        disc <= 1'b0;
        flag <= 1'b0;
        err  <= 1'b0;

        // Error output: asserted when in error state
        if (next_state == S7p) begin
            err <= 1'b1;
        end

        // Discard output: when previous state is S5 and input is zero (next_state == S0)
        if ((state == S5) && (in == 1'b0)) begin
            disc <= 1'b1;
        end

        // Flag output: when previous state is S6 and input is zero (next_state == S0)
        if ((state == S6) && (in == 1'b0)) begin
            flag <= 1'b1;
        end

        prev_in <= in;
    end
end

endmodule