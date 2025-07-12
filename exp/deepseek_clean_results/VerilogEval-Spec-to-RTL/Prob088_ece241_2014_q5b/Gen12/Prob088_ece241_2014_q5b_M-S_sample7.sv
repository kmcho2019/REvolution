module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state;  // 0 = A, 1 = B

    // Output and next state logic
    assign z = state ^ x;

    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to state A
        end else begin
            state <= state | x;
        end
    end

endmodule