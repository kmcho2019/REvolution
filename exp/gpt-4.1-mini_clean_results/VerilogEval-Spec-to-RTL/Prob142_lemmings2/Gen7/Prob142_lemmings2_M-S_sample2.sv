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
    // direction: 0=left, 1=right
    reg direction;
    // falling: 0=walking, 1=falling
    reg falling;

    wire bump = bump_left | bump_right;
    wire both_bump = bump_left & bump_right;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk left on reset
            falling   <= 1'b0; // start walking, not falling
        end else begin
            if (falling) begin
                if (ground) begin
                    falling <= 1'b0; // stop falling when ground appears
                    // direction unchanged
                end
                // else remain falling, direction unchanged
            end else begin
                // walking
                if (!ground) begin
                    falling <= 1'b1; // start falling
                    // direction unchanged
                end else if (bump) begin
                    if (both_bump) begin
                        direction <= ~direction; // flip direction if both bumps
                    end else if (bump_left) begin
                        direction <= 1'b1; // bump_left means walk right
                    end else begin
                        direction <= 1'b0; // bump_right means walk left
                    end
                end
                // else no change
            end
        end
    end

    assign walk_left  = (direction == 1'b0) && (falling == 1'b0);
    assign walk_right = (direction == 1'b1) && (falling == 1'b0);
    assign aaah       = falling;

endmodule