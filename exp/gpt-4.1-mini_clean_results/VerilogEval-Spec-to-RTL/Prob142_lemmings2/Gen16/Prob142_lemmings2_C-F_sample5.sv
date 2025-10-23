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

    // Separate registers for falling state and walking direction
    // direction: 0 = walk left, 1 = walk right
    reg falling, direction;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0;    // start not falling
            direction <= 1'b0;    // start walking left
        end else begin
            // Update falling state first based on ground
            if (falling) begin
                // If falling, remain falling unless ground returns
                falling <= (ground) ? 1'b0 : 1'b1;
                // Direction unchanged while falling
            end else begin
                // If not falling, start falling if ground lost
                falling <= (ground) ? 1'b0 : 1'b1;
                // Only update direction if still walking (not falling)
                if (ground && (bump_left || bump_right)) begin
                    if (bump_left && bump_right)
                        direction <= ~direction; // flip direction
                    else if (bump_left)
                        direction <= 1'b1;       // walk right
                    else if (bump_right)
                        direction <= 1'b0;       // walk left
                end
            end
        end
    end

    // Moore outputs directly from state regs
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule