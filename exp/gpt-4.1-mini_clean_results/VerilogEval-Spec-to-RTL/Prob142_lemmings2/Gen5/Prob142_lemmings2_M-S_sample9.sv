module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    reg falling;   // 1 = falling, 0 = walking
    reg direction; // 0 = left, 1 = right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0; // start walking
            direction <= 1'b0; // start walking left
        end else begin
            if (falling) begin
                // Falling: stay falling until ground returns
                if (ground)
                    falling <= 1'b0; // Landed
            end else begin
                // Walking on ground
                if (!ground) begin
                    falling <= 1'b1; // Start falling
                end else begin
                    // Update direction only when bumped on ground
                    if (bump_left || bump_right) begin
                        direction <= (bump_left ? 1'b1 : 1'b0);
                        // If both bumps (bump_left and bump_right), bump_left takes precedence => direction=1 (right)
                        // This matches "if both bumps, flip direction" => to fix, add logic below:
                        if (bump_left && bump_right)
                            direction <= ~direction; // flip direction if both bumps
                    end
                    // else direction unchanged
                end
            end
        end
    end

    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling & direction;

endmodule