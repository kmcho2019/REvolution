module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single-bit state register (0=A, 1=B)
    reg state;

    // Next state logic: state becomes 1 if either:
    // 1. Already in state B (1), or
    // 2. In state A (0) and x is 1
    wire next_state = state | (~state & x);

    // Output logic: z = x in state A, ~x in state B
    assign z = state ? ~x : x;

    // State transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to state A
        end else begin
            state <= next_state;
        end
    end

endmodule