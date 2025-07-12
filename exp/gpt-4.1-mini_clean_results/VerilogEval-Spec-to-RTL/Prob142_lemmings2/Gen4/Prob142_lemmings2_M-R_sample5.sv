module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);
    reg ground_d;
    reg falling;
    reg walk_dir; // 0 = left, 1 = right
    reg saved_dir; // walking direction before falling

    // Detect falling start: ground_d=1 and ground=0
    wire falling_start = (ground_d == 1'b1) && (ground == 1'b0);
    // Detect landing: ground_d=0 and ground=1
    wire landing = (ground_d == 1'b0) && (ground == 1'b1);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0;
            walk_dir  <= 1'b0; // walk left on reset
            saved_dir <= 1'b0;
            ground_d  <= 1'b1; // assume start on ground
        end else begin
            ground_d <= ground;

            if (falling) begin
                // While falling
                if (landing) begin
                    falling  <= 1'b0;
                    walk_dir <= saved_dir; // restore direction
                end
                // Else remain falling and ignore bumps
            end else begin
                // Not falling
                if (falling_start) begin
                    falling   <= 1'b1;
                    saved_dir <= walk_dir; // save current direction
                end else begin
                    // Update walking direction on bump
                    if (bump_left || bump_right) begin
                        walk_dir <= ~walk_dir;
                    end
                end
            end
        end
    end

    assign walk_left  = (walk_dir == 1'b0) && !falling;
    assign walk_right = (walk_dir == 1'b1) && !falling;
    assign aaah       = falling;

endmodule