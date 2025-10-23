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

    reg direction;  // 0=left, 1=right
    reg falling;

    wire falling_next;
    wire direction_next;
    wire direction_en, falling_en;

    // Falling next state logic
    // If currently falling: keep falling while ground=0, else stop falling
    // If currently walking: start falling if ground=0, else no change
    assign falling_next = falling ? (~ground) : (~ground);

    assign falling_en = (falling != falling_next);

    // Direction next state logic
    // Direction changes only when not falling and bumped
    wire bump_any = bump_left | bump_right;
    // When bumped both sides, direction toggles
    // When bumped left only, direction=1 (walk right)
    // When bumped right only, direction=0 (walk left)
    wire direction_bump_toggle = bump_left & bump_right;

    assign direction_next = (~falling && bump_any) ?
                             (direction_bump_toggle ? ~direction : (bump_left ? 1'b1 : 1'b0))
                             : direction;

    assign direction_en = (direction != direction_next) && (~falling);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0;  // walk left
            falling <= 1'b0;
        end else begin
            // Update falling unconditionally if changed
            if (falling_en)
                falling <= falling_next;

            // Update direction only if enabled (bumped and walking)
            if (direction_en)
                direction <= direction_next;
        end
    end

    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule