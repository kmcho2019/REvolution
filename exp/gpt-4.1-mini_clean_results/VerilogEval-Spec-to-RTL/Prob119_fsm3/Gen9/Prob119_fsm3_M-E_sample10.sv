module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // One-hot encoding for states
    // state bits: [D C B A]
    // Only one bit is high at a time
    reg state_a, state_b, state_c, state_d;
    reg next_a, next_b, next_c, next_d;

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset to state A only
            state_a <= 1'b1;
            state_b <= 1'b0;
            state_c <= 1'b0;
            state_d <= 1'b0;
        end else begin
            state_a <= next_a;
            state_b <= next_b;
            state_c <= next_c;
            state_d <= next_d;
        end
    end

    // Next state logic based on current state and input
    always @(*) begin
        // Default next states to zero
        next_a = 1'b0;
        next_b = 1'b0;
        next_c = 1'b0;
        next_d = 1'b0;

        if (state_a) begin
            next_a = (in == 1'b0);
            next_b = (in == 1'b1);
        end else if (state_b) begin
            next_c = (in == 1'b0);
            next_b = (in == 1'b1);
        end else if (state_c) begin
            next_a = (in == 1'b0);
            next_d = (in == 1'b1);
        end else if (state_d) begin
            next_c = (in == 1'b0);
            next_b = (in == 1'b1);
        end else begin
            // In case of invalid state, reset to A
            next_a = 1'b1;
        end
    end

    // Output logic: output = 1 when in state D
    assign out = state_d;

endmodule