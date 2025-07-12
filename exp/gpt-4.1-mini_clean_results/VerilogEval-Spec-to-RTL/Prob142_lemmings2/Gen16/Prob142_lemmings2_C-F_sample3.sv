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

    // State bits:
    // bit1 = falling (1 = falling, 0 = walking)
    // bit0 = direction (0 = left, 1 = right)
    reg falling;
    reg direction;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0; // start walking
            direction <= 1'b0; // start walking left
        end else begin
            // Update falling based on ground first
            if (falling) begin
                // Currently falling
                if (ground)
                    falling <= 1'b0; // landed
                else
                    falling <= 1'b1; // keep falling
                // direction unchanged while falling
            end else begin
                // Currently walking
                if (~ground)
                    falling <= 1'b1; // start falling
                else
                    falling <= 1'b0; // keep walking

                // Update direction only when walking and bumped
                if (ground && (bump_left || bump_right)) begin
                    if (bump_left && bump_right)
                        direction <= ~direction;    // flip direction
                    else if (bump_left)
                        direction <= 1'b1;          // walk right
                    else if (bump_right)
                        direction <= 1'b0;          // walk left
                end
            end
        end
    end

    // Moore outputs
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule