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
            falling   <= 1'b0;  // start walking
            direction <= 1'b0;  // walk left
        end else begin
            if (falling) begin
                // Falling state: wait for ground to come back
                if (ground)
                    falling <= 1'b0;  // resume walking
                // else keep falling
                // direction unchanged while falling
            end else begin
                // Walking state
                if (!ground) begin
                    falling <= 1'b1;  // start falling
                end else begin
                    // On ground and walking, update direction based on bumps
                    // bump_left => walk right (direction=1)
                    // bump_right => walk left (direction=0)
                    // if both bump_left and bump_right => flip direction
                    if (bump_left && bump_right) begin
                        direction <= ~direction;
                    end else if (bump_left) begin
                        direction <= 1'b1;
                    end else if (bump_right) begin
                        direction <= 1'b0;
                    end
                    // else direction unchanged
                end
            end
        end
    end

    // Output logic (Moore)
    assign aaah       = falling;
    assign walk_left  = ~falling & (direction == 1'b0);
    assign walk_right = ~falling & (direction == 1'b1);

endmodule