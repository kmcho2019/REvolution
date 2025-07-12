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

    reg direction; // 0=left, 1=right
    reg falling;

    // Next state logic for falling
    wire next_falling = falling ? (~ground) : (~ground);

    // Next state logic for direction: update only if not falling and bumped
    wire bump_any = bump_left | bump_right;
    wire both_bumps = bump_left & bump_right;

    wire [0:0] next_direction = (falling) ? direction : 
                                (bump_any ? (both_bumps ? ~direction :
                                    bump_left ? 1'b1 : 1'b0) : direction);

    // Update falling register
    always @(posedge clk or posedge areset) begin
        if (areset)
            falling <= 1'b0;
        else
            falling <= next_falling;
    end

    // Update direction register only when enabled (walking and bumped)
    wire direction_en = ~falling & bump_any;
    always @(posedge clk or posedge areset) begin
        if (areset)
            direction <= 1'b0; // walk left on reset
        else if (direction_en)
            direction <= next_direction;
    end

    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule