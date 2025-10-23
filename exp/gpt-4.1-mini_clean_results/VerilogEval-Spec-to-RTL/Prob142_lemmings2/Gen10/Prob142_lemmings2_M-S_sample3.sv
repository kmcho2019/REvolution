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

    reg direction;  // 0=left, 1=right
    reg falling;    // 0=walking,1=falling

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk left
            falling   <= 1'b0; // walking
        end else begin
            if (falling == 1'b0) begin
                // Walking state
                if (ground == 1'b0) begin
                    // start falling, keep direction
                    falling <= 1'b1;
                end else begin
                    // On ground and walking: bumps may change direction
                    if (bump_left && bump_right) begin
                        direction <= ~direction;  // flip direction
                    end else if (bump_left) begin
                        direction <= 1'b1;  // walk right
                    end else if (bump_right) begin
                        direction <= 1'b0;  // walk left
                    end
                end
            end else begin
                // Falling state
                if (ground == 1'b1) begin
                    // Ground appeared, resume walking same direction
                    falling <= 1'b0;
                end
                // else remain falling, direction unchanged
            end
        end
    end

    assign aaah       = falling;
    assign walk_left  = ~falling & (direction == 1'b0);
    assign walk_right = ~falling & (direction == 1'b1);

endmodule