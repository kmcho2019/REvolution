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
    reg falling;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0;  // walk left
            falling   <= 1'b0;
        end else begin
            if (falling) begin
                // currently falling
                if (ground) begin
                    falling <= 1'b0;  // landed
                    // direction unchanged
                end
                // else keep falling and direction
            end else begin
                // currently walking
                if (~ground) begin
                    falling <= 1'b1;  // start falling
                end else begin
                    // on ground and walking: update direction on bumps
                    if (bump_left || bump_right) begin
                        direction <= ~direction;
                    end
                end
            end
        end
    end

    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling & direction;

endmodule