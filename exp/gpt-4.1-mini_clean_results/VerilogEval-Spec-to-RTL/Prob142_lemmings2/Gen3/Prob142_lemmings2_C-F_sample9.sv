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

    // State registers
    reg falling;       // 1 = falling, 0 = walking
    reg direction;     // 0 = left, 1 = right

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0;  // Start walking
            direction <= 1'b0;  // Start walking left
        end else begin
            if (falling) begin
                // Stay falling until ground returns
                if (ground)
                    falling <= 1'b0;
                // else remain falling
                // direction unchanged while falling
            end else begin
                // Not falling
                if (!ground) begin
                    falling <= 1'b1;  // Start falling
                end else begin
                    // On ground and walking: update direction based on bumps
                    if (bump_left && bump_right) begin
                        // Both bumps: flip direction
                        direction <= ~direction;
                    end else if (bump_left) begin
                        direction <= 1'b1;  // Walk right
                    end else if (bump_right) begin
                        direction <= 1'b0;  // Walk left
                    end
                    // else keep direction unchanged
                end
            end
        end
    end

    // Moore outputs
    assign aaah       = falling;
    assign walk_left  = (~falling) & (direction == 1'b0);
    assign walk_right = (~falling) & (direction == 1'b1);

endmodule