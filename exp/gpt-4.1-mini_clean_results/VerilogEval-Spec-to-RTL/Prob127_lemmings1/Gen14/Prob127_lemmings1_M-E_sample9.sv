module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg direction; // 0 = walk_left, 1 = walk_right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk_left on reset
        end else begin
            if (bump_left && !bump_right) begin
                direction <= 1'b1; // bumped left only, walk right
            end else if (!bump_left && bump_right) begin
                direction <= 1'b0; // bumped right only, walk left
            end else if (bump_left && bump_right) begin
                direction <= 1'b0; // bumped both, force walk_left (alternate rule)
            end
            // else no bump, hold current direction
        end
    end

    assign walk_left  = (direction == 1'b0);
    assign walk_right = (direction == 1'b1);

endmodule