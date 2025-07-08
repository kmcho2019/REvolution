module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

// State encoding
typedef enum logic [3:0] {
    S0 = 4'd0, // no consecutive ones
    S1 = 4'd1, // 1 consecutive one
    S2 = 4'd2, // 2 consecutive ones
    S3 = 4'd3, // 3 consecutive ones
    S4 = 4'd4, // 4 consecutive ones
    S5 = 4'd5, // 5 consecutive ones
    S6 = 4'd6, // 6 consecutive ones
    S7 = 4'd7  // 7 or more consecutive ones (error)
} state_t;

state_t state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

always @* begin
    // Default next_state is current state
    next_state = state;
    case (state)
        S0: begin
            if (in == 1'b1) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if (in == 1'b1) next_state = S2;
            else next_state = S0;
        end
        S2: begin
            if (in == 1'b1) next_state = S3;
            else next_state = S0;
        end
        S3: begin
            if (in == 1'b1) next_state = S4;
            else next_state = S0;
        end
        S4: begin
            if (in == 1'b1) next_state = S5;
            else next_state = S0;
        end
        S5: begin
            if (in == 1'b1) next_state = S6;
            else next_state = S0;
        end
        S6: begin
            if (in == 1'b1) next_state = S7;
            else next_state = S0;
        end
        S7: begin
            // Stay in error state if input is 1, else reset to S0
            if (in == 1'b1) next_state = S7;
            else next_state = S0;
        end
        default: next_state = S0;
    endcase
end

// Outputs are Moore type: depend only on state
// disc = 1 when a zero follows 5 consecutive ones (i.e., state was S5 and next input=0)
// flag = 1 when a zero follows 6 consecutive ones (i.e., state was S6 and next input=0)
// err = 1 when in S7 (7 or more consecutive ones)

always @(posedge clk) begin
    if (reset) begin
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        // By FSM definition, the outputs are asserted one cycle AFTER the pattern happens
        // Because outputs depend on current state (not input),
        // disc and flag are asserted in the state following the pattern detection.
        // We can define outputs purely from current state.
        disc <= (state == S0) && (next_state == S0) && (in == 1'b0) ? 1'b0 : 1'b0; 
        // This is not the correct way. We need outputs based on current state only.
        // The pattern 0111110 means after five consecutive ones, next input is 0.
        // But since next_state depends on input, we can use current state to know what we saw previously.

        // Proper approach:
        // For Moore FSM, outputs depend only on current state.
        // Outputs asserted on clock cycle after the condition occurs.
        // So when state == S5, disc=1 (means last input was the zero after 5 ones)
        // When state == S6, flag=1 (means last input was zero after 6 ones)
        // When state == S7, err=1 (7 or more ones)

        disc <= (state == S5);
        flag <= (state == S6);
        err <= (state == S7);
    end
end

endmodule