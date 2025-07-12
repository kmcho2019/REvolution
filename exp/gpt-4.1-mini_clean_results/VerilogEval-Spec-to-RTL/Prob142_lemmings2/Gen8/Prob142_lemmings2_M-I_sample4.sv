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

    wire any_bump = bump_left | bump_right;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0; // start walking
            direction <= 1'b0; // start walking left
        end else begin
            if (falling) begin
                // Falling: remain falling until ground returns
                if (ground)
                    falling <= 1'b0;
            end else begin
                // Walking on ground
                if (!ground) begin
                    falling <= 1'b1; // start falling
                end else begin
                    // Update direction only when bumped on ground and walking
                    if (any_bump)
                        direction <= ~direction; // flip direction on any bump
                    // else direction unchanged
                end
            end
        end
    end

    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling & direction;

endmodule