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

    reg walk_left_reg, walk_right_reg, falling_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left_reg  <= 1'b1;  // start walking left
            walk_right_reg <= 1'b0;
            falling_reg    <= 1'b0;
        end else begin
            if (!falling_reg) begin
                // Walking state
                if (!ground) begin
                    // start falling, keep direction
                    falling_reg <= 1'b1;
                end else begin
                    // handle bumps to change direction
                    if (bump_left || bump_right) begin
                        // Flip direction on any bump
                        walk_left_reg  <= walk_right_reg;
                        walk_right_reg <= walk_left_reg;
                    end
                end
            end else begin
                // Falling state
                if (ground) begin
                    // stop falling, resume walking in same direction
                    falling_reg <= 1'b0;
                end
                // bumps ignored while falling
            end
        end
    end

    assign walk_left  = walk_left_reg & ~falling_reg;
    assign walk_right = walk_right_reg & ~falling_reg;
    assign aaah       = falling_reg;

endmodule