module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single flip-flop representing state token
    reg state_token;

    // Next token position logic
    wire next_token = state_token ? 1'b1 : x;

    // Output is simply XOR of token position and input
    assign z = state_token ^ x;

    // State transition with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_token <= 1'b0;  // Reset puts token in position A (0)
        end
        else begin
            state_token <= next_token;
        end
    end

endmodule