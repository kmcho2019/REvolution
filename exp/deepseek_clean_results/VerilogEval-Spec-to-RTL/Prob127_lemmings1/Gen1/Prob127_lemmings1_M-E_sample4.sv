module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg direction;  // 0=left, 1=right

    // Direction update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0;  // Reset to walk left
        end else begin
            // Toggle direction when bumped (XOR acts as controlled toggle)
            direction <= direction ^ (bump_left | bump_right) ^ (bump_left & bump_right);
        end
    end

    // Output logic
    assign walk_left = ~direction;
    assign walk_right = direction;

endmodule