module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg direction;  // 0 = left, 1 = right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0;  // Start walking left
        end else if (bump_left || bump_right) begin
            direction <= direction ^ 1'b1;  // Toggle direction when bumped
        end
    end

    assign walk_left = ~direction;
    assign walk_right = direction;

endmodule