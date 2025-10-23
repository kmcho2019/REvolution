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
            direction <= 1'b0; // walk left initially
        end else begin
            if (falling) begin
                if (ground)
                    falling <= 1'b0; // landed
            end else begin
                if (!ground)
                    falling <= 1'b1; // start falling
                else if (bump_left || bump_right) begin
                    if (bump_left && bump_right)
                        direction <= ~direction; // both bumps flip direction
                    else
                        direction <= bump_left ? 1'b1 : 1'b0; // bump left -> walk right, bump right -> walk left
                end
            end
        end
    end

    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule