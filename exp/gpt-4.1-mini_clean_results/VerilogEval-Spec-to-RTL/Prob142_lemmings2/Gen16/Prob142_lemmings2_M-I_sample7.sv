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

    reg direction; // 0 = left, 1 = right
    reg falling;

    reg next_direction;
    reg next_falling;

    wire bumped = bump_left | bump_right;

    always @* begin
        if (falling) begin
            // While falling, ignore bumps, wait for ground
            next_falling   = ground ? 1'b0 : 1'b1;
            next_direction = direction; // preserve direction during fall
        end else begin
            // On ground
            if (!ground) begin
                // Start falling, keep direction
                next_falling   = 1'b1;
                next_direction = direction;
            end else if (bumped) begin
                // Switch direction if bumped
                next_falling   = 1'b0;
                next_direction = ~direction;
            end else begin
                // Stay walking same direction
                next_falling   = 1'b0;
                next_direction = direction;
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk left
            falling   <= 1'b0; // not falling
        end else begin
            direction <= next_direction;
            falling   <= next_falling;
        end
    end

    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule