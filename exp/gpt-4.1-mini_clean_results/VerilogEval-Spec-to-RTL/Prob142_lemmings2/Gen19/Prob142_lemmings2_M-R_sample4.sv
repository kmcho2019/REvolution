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

    // Separate state bits for clarity
    reg falling, direction;
    wire next_falling, next_direction;

    // Next-state logic for falling
    // Falling starts when ground=0; ends when ground=1
    assign next_falling = falling ? ground : (falling | ~ground);

    // Next-state logic for direction
    // Update direction only when walking (falling=0) and bumps occur
    // bump_left -> direction = 1 (walk right)
    // bump_right -> direction = 0 (walk left)
    // both bumps simultaneously flip direction
    // If no bumps or falling=1, direction stays same
    wire both_bump = bump_left & bump_right;
    wire bump_change = bump_left | bump_right;

    assign next_direction = (falling) ? direction : 
                            (both_bump) ? ~direction :
                            (bump_left & ~bump_right) ? 1'b1 :
                            (~bump_left & bump_right) ? 1'b0 :
                            direction;

    // Sequential update with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling  <= 1'b0;    // walk state
            direction <= 1'b0;   // walk left initially
        end else begin
            falling  <= next_falling;
            direction <= next_direction;
        end
    end

    // Outputs derived from state bits (Moore outputs)
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule