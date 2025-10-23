module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state encoding
    reg state_B, state_A;
    reg next_state_B, next_state_A;

    // Next state logic combinational block
    always @(*) begin
        // Default next state assignments
        next_state_B = 1'b0;
        next_state_A = 1'b0;

        if (state_B) begin
            // From B: if in=0 -> A else B
            if (in == 1'b0) begin
                next_state_A = 1'b1;
            end else begin
                next_state_B = 1'b1;
            end
        end else if (state_A) begin
            // From A: if in=0 -> B else A
            if (in == 1'b0) begin
                next_state_B = 1'b1;
            end else begin
                next_state_A = 1'b1;
            end
        end else begin
            // Safety: if no state is set, go to reset state B
            next_state_B = 1'b1;
        end
    end

    // State registers with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state_B <= 1'b1;
            state_A <= 1'b0;
        end else begin
            state_B <= next_state_B;
            state_A <= next_state_A;
        end
    end

    // Output logic: out=1 when in state B, else 0
    assign out = state_B;

endmodule