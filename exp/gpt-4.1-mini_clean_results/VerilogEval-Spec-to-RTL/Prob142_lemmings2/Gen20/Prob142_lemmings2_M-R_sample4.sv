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

    // Separate state bits as registers
    reg falling;
    reg direction; // 0 = left, 1 = right

    // Next state combinational signals
    wire next_falling;
    wire next_direction;

    // Determine next falling state
    // Falling starts when ground=0; ends when ground=1 and falling=1
    assign next_falling = falling ? (ground ? 1'b0 : 1'b1)  // if falling, stop falling when ground returns
                                : (ground ? 1'b0 : 1'b1); // if walking, start falling if ground lost

    // Determine next direction only when not falling
    // During fall or transitions to/from fall, direction unchanged
    wire bump = bump_left | bump_right;
    assign next_direction =
        falling ? direction :                 // preserve direction when falling
        (!ground) ? direction :               // preserve direction when ground just lost
        (bump_left && bump_right) ? ~direction : // both bumps flips direction
        bump_left ? 1'b1 :                   // bump left -> walk right
        bump_right ? 1'b0 :                  // bump right -> walk left
        direction;                          // else hold current direction

    // Sequential logic with async reset for falling and direction
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0;    // reset to walking (not falling)
            direction <= 1'b0;    // reset to walking left
        end else begin
            falling   <= next_falling;
            direction <= next_direction;
        end
    end

    // Outputs decoded from registers (Moore outputs)
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule