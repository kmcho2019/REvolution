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

    // Separate direction and falling state bits
    reg dir;      // 0 = left, 1 = right
    reg falling;  // 0 = walking, 1 = falling

    // Next direction logic: only updates when not falling and ground present
    wire dir_next;
    wire bump_any = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    // If falling, direction does not change
    // If walking and bumped on either or both sides, flip direction
    // Else keep direction
    assign dir_next = (falling) ? dir :
                      (ground ? 
                         ((bump_left || bump_right) ? ~dir : dir)
                      : dir);

    // Next falling logic: 
    // If ground goes low, start falling (falling=1)
    // If ground high and was falling, stop falling (falling=0)
    // Else keep current falling state
    wire falling_next = ground ? 1'b0 : 1'b1;

    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            dir <= 1'b0;     // walk left
            falling <= 1'b0; // not falling
        end else begin
            dir <= dir_next;
            falling <= falling_next;
        end
    end

    // Outputs: Moore machine output depends only on current state
    assign aaah       = falling;
    assign walk_left  = ~falling & ~dir;
    assign walk_right = ~falling & dir;

endmodule