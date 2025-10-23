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

    // Separate state bits
    reg falling;
    reg direction; // 0: left, 1: right

    wire bump_both = bump_left & bump_right;

    // Next state logic for falling
    wire next_falling;
    assign next_falling = (falling) ? (~ground) : (~ground);

    // Next state logic for direction
    wire next_direction;
    assign next_direction = falling ? direction :
                          (bump_both ? ~direction :
                          bump_left ? 1'b1 : // walk right
                          bump_right ? 1'b0 : // walk left
                          direction);

    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0;
            direction <= 1'b0; // walk left
        end else begin
            falling   <= next_falling;
            direction <= next_direction;
        end
    end

    // Moore outputs
    assign aaah       = falling;
    assign walk_left  = (~falling) & (~direction);
    assign walk_right = (~falling) & direction;

endmodule