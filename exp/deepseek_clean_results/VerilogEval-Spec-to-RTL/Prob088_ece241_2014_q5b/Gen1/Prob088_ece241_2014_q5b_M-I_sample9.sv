module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding
    reg state_A, state_B;

    // Next state logic simplified (state_B persists once entered)
    wire next_state_A = state_A & ~x;
    wire next_state_B = (state_A & x) | state_B;

    // Output logic optimized (z = x in A, ~x in B)
    assign z = state_A ? x : ~x;

    // State transition with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end
        else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

endmodule