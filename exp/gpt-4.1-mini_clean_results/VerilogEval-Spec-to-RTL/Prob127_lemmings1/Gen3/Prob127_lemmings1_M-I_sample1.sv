module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state; // 0 = walk_left, 1 = walk_right

    // Asynchronous reset, synchronous state transition
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // walk_left
        end else if (bump_left || bump_right) begin
            state <= ~state; // toggle direction on bump
        end
    end

    assign walk_left  = ~state;
    assign walk_right = state;

endmodule