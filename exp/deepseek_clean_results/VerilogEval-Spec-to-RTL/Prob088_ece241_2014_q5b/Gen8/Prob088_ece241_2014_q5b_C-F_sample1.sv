module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state_A, state_B;
    reg next_state_A, next_state_B;

    // Simplified next state logic
    always @(*) begin
        next_state_A = state_A & ~x;
        next_state_B = (state_A & x) | state_B;
    end

    // Registered output for better timing
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            z <= 1'b0;
        end
        else begin
            z <= state_A ? x : ~x;
        end
    end

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