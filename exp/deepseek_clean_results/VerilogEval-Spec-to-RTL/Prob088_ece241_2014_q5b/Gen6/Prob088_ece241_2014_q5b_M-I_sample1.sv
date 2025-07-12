module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // One-hot state encoding
    reg state_A, state_B;

    // State transition with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
            z <= 1'b0;
        end
        else begin
            // Simplified state transition
            state_A <= state_A & ~x;
            state_B <= (state_A & x) | state_B;
            
            // Registered output reduces critical path
            z <= state_A ? x : ~x;
        end
    end

endmodule