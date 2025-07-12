module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // Gray-coded states: 0=LEFT, 1=RIGHT
    reg state;

    // Dual-edge triggered state machine with priority logic
    always @(posedge clk or posedge areset or negedge clk) begin
        if (areset) begin
            state <= 1'b0; // LEFT state
        end else begin
            // Priority: right bump over left bump
            if (bump_right)
                state <= 1'b0; // Switch to LEFT
            else if (bump_left)
                state <= 1'b1; // Switch to RIGHT
        end
    end

    // Direct output mapping from state register
    assign walk_left = ~state;
    assign walk_right = state;

endmodule