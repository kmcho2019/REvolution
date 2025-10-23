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

    reg falling, direction; // falling=1 means falling, direction=0 left, 1 right
    reg falling_next, direction_next;

    wire bumped = bump_left | bump_right;

    always @* begin
        if (falling) begin
            // While falling, remain falling until ground returns; direction preserved
            falling_next   = ground ? 1'b0 : 1'b1;
            direction_next = direction;
        end else begin
            // Walking on ground
            if (!ground) begin
                // Start falling, preserve direction
                falling_next   = 1'b1;
                direction_next = direction;
            end else if (bumped) begin
                // Switch direction if bumped
                falling_next   = 1'b0;
                direction_next = ~direction;
            end else begin
                // Continue walking same direction
                falling_next   = 1'b0;
                direction_next = direction;
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0;
            direction <= 1'b0; // walk left on reset
        end else begin
            falling   <= falling_next;
            direction <= direction_next;
        end
    end

    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule