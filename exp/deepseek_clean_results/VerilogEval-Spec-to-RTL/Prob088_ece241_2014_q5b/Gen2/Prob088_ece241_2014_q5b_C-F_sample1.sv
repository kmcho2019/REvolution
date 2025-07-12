module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single state register (0=A, 1=B)
    reg state_B;

    // Next state logic - simplified from Example 1
    wire next_state_B = state_B | (~state_B & x);

    // Output logic - clear expression from Example 2
    assign z = state_B ? ~x : x;

    // State transition with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;
        end
        else begin
            state_B <= next_state_B;
        end
    end

endmodule