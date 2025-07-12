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
            falling   <= 1'b0;
            direction <= 1'b0;
        end else if (falling) begin
            if (ground)
                falling <= 1'b0; // land, resume walking same direction
        end else begin
            if (!ground) begin
                falling <= 1'b1; // start falling
            end else if (bump_left || bump_right) begin
                // flip direction if bumped on left or right
                direction <= direction ^ 1'b1;
            end
        end
    end

    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling & direction;

endmodule