module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // Registers to hold direction and falling status
    reg direction; // 0 = left, 1 = right
    reg falling;   // 0 = walking, 1 = falling

    // Combinational logic to detect bumps on walking state
    wire bumped = bump_left | bump_right;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset to walking left
            direction <= 1'b0; // left
            falling   <= 1'b0; // walking
        end else begin
            if (falling) begin
                // Currently falling
                if (ground) begin
                    // Ground reappeared, resume walking with same direction
                    falling <= 1'b0;
                    // direction unchanged
                end
                // else keep falling, no direction change
            end else begin
                // Currently walking
                if (!ground) begin
                    // No ground, start falling, direction retained
                    falling <= 1'b1;
                end else if (bumped) begin
                    // On bump on either side, toggle direction
                    // This correctly handles bump_left, bump_right, or both
                    direction <= ~direction;
                end
                // else keep walking same direction
            end
        end
    end

    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;
    assign aaah       =  falling;

endmodule