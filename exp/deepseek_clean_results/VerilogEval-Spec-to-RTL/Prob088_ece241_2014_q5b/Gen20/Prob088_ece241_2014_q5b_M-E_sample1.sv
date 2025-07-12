module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state;  // 0 = A, 1 = B

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // Reset to state A
        else begin
            if (state == 1'b0)  // State A
                state <= x ? 1'b1 : 1'b0;
            else  // State B
                state <= 1'b1;  // Stay in B regardless of x
        end
    end

    // Output logic: z = x when state A, ~x when state B
    assign z = state ^ x;

endmodule