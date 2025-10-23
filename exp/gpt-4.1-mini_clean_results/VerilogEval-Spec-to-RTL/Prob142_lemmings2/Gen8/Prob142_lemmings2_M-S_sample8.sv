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
    reg falling;   // 0 = walking, 1 = falling

    // Next direction combinational logic
    wire bump = bump_left | bump_right;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk left on reset
            falling   <= 1'b0; // start walking, not falling
        end else begin
            if (falling) begin
                // Falling state: wait for ground to return, ignore bumps
                if (ground)
                    falling <= 1'b0; // stop falling, resume walking same direction
            end else begin
                // Walking state
                if (!ground) begin
                    falling <= 1'b1; // start falling
                end else if (bump) begin
                    // On ground, bumps flip direction
                    direction <= ~direction;
                end
            end
        end
    end

    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling & direction;

endmodule