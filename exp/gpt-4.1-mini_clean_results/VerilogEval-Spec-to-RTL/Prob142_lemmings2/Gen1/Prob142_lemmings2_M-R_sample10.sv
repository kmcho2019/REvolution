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

    // Registers for FSM
    reg falling;        // 1 = falling, 0 = walking
    reg direction;      // 0 = left, 1 = right

    // Asynchronous reset and sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0;  // start walking
            direction <= 1'b0;  // walk left
        end else begin
            if (falling) begin
                // Remain falling until ground returns
                if (ground)
                    falling <= 1'b0;  // stop falling and resume walking
                // else falling remains
                // direction unchanged during falling
            end else begin
                // Not falling
                if (!ground) begin
                    falling <= 1'b1;  // start falling
                end else begin
                    // On ground and walking: update direction based on bumps
                    // According to problem:
                    // bump_left = 1 means switch direction to walk right (direction=1)
                    // bump_right= 1 means switch direction to walk left (direction=0)
                    // Both bumps simultaneously also cause direction switch accordingly (direction changes)
                    if (bump_left && bump_right) begin
                        // If both bumps, flip direction
                        direction <= ~direction;
                    end else if (bump_left) begin
                        direction <= 1'b1;  // walk right
                    end else if (bump_right) begin
                        direction <= 1'b0;  // walk left
                    end
                    // else keep direction unchanged
                end
            end
        end
    end

    // Output combinational logic
    assign aaah       = falling;
    assign walk_left  = (~falling) & (direction == 1'b0);
    assign walk_right = (~falling) & (direction == 1'b1);

endmodule