module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg direction; // 1: walking right, 0: walking left
reg falling;   // 1: falling, 0: walking

always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 1'b0; // Reset to walking left
        falling <= 1'b0;  // Not falling
    end else begin
        if (~ground && ~falling) begin // Transition to falling
            falling <= 1'b1;
        end else if (ground && falling) begin // Transition to walking
            falling <= 1'b0;
        end else if (~falling && (bump_left || bump_right)) begin
            // Switch direction if bumped and not falling
            direction <= ~direction;
        end
    end
end

always @(*) begin
    walk_left = ~direction && ~falling;
    walk_right = direction && ~falling;
    aaah = falling;
end

endmodule