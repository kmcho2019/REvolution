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

    // State bits
    // direction: 0 = left, 1 = right
    // falling:   0 = walking, 1 = falling
    reg direction;
    reg falling;

    // Next state signals
    wire next_direction;
    wire next_falling;

    // Determine next falling state: falling if no ground, walking if ground
    assign next_falling = (ground) ? 1'b0 : 1'b1;

    // Determine next direction:
    // - If falling, direction unchanged
    // - If walking and bumped (left or right or both), direction changes accordingly:
    //   If bump_left=1 => direction=1 (walk right)
    //   If bump_right=1 => direction=0 (walk left)
    //   If both bumped => still flip direction accordingly (both bumped means direction flips)
    //   Note bump on both sides also causes flip direction
    // Careful: when bump_left and bump_right both 1, the direction flips.
    // Current direction:
    // walking left (direction=0), bumped left => walk right (direction=1)
    // walking right(direction=1), bumped right=> walk left (direction=0)
    // bump on both sides flips direction always
    // So if both bumps: direction flips (direction ^ 1)
    // else if bump_left: direction = 1 (right)
    // else if bump_right: direction = 0 (left)
    // else no bump: direction unchanged

    wire bump_both = bump_left & bump_right;
    wire bumped = bump_left | bump_right;

    assign next_direction = falling ? direction : (
        bump_both ? ~direction :
        bump_left ? 1'b1 :
        bump_right ? 1'b0 :
        direction
    );

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walking left
            falling   <= 1'b0; // not falling
        end else begin
            direction <= next_direction;
            falling   <= next_falling;
        end
    end

    // Outputs (Moore)
    assign walk_left  = (falling == 1'b0) && (direction == 1'b0);
    assign walk_right = (falling == 1'b0) && (direction == 1'b1);
    assign aaah       = (falling == 1'b1);

endmodule