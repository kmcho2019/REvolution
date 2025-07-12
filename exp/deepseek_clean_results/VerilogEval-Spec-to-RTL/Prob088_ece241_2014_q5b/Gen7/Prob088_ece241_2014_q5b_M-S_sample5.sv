module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single state register (0=A, 1=B)
    reg state;

    // Next state logic
    wire next_state = state | x;

    // Output is XOR of state and x
    assign z = state ^ x;

    // State transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
        end
        else begin
            state <= next_state;
        end
    end

endmodule