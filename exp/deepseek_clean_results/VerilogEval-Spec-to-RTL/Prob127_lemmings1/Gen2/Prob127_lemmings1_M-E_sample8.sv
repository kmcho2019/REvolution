module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg direction;  // 0=left, 1=right

    // Toggle direction when bumped
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0;  // Reset to walk left
        end else if (bump_left || bump_right) begin
            direction <= ~direction;  // Toggle direction on any bump
        end
    end

    // Output logic
    assign walk_left = ~direction;
    assign walk_right = direction;

endmodule