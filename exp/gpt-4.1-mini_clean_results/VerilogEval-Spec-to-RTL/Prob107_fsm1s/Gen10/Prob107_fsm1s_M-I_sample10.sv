module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state encoding
    // state_b = 1 if in state B (reset state)
    // state_a = 1 if in state A
    reg state_b, state_a;
    reg next_state_b, next_state_a;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state_b <= 1'b1; // reset to state B
            state_a <= 1'b0;
        end else begin
            state_b <= next_state_b;
            state_a <= next_state_a;
        end
    end

    // Next state combinational logic simplified for one-hot FSM
    always @(*) begin
        // Default assignments to prevent latches
        next_state_b = 1'b0;
        next_state_a = 1'b0;
        if (state_b) begin
            if (in == 1'b0)
                next_state_a = 1'b1;
            else
                next_state_b = 1'b1;
        end else begin // state_a
            if (in == 1'b0)
                next_state_b = 1'b1;
            else
                next_state_a = 1'b1;
        end
    end

    // Output is 1 when in state B, 0 when in state A
    assign out = state_b;

endmodule