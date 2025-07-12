module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State register (0 = left, 1 = right)
    reg state;

    // Next state logic using arithmetic operations
    wire next_state = state ^ (bump_left & ~state) ^ (bump_right & state);

    // State transition
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to walk left
        end else begin
            state <= next_state;
        end
    end

    // Output assignments
    assign walk_left = ~state;
    assign walk_right = state;

endmodule