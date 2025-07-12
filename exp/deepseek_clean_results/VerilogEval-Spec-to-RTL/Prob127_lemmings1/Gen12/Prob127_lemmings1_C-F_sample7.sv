module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    reg state;  // 0=left, 1=right

    // Optimized state transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to walk left
        end
        else if ((state && bump_right) || (!state && bump_left)) begin
            state <= ~state;  // Toggle direction when bumped
        end
    end

    // Direct output assignments
    assign walk_left = ~state;
    assign walk_right = state;

endmodule