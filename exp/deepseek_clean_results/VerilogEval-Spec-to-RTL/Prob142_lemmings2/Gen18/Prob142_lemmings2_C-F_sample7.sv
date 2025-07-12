module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    reg direction;  // 0=left, 1=right
    reg falling;

    // Next state logic
    wire next_falling = !ground;
    wire next_direction = (direction ^ (bump_right & direction | bump_left & !direction)) & !falling;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 1'b0;  // walk left
            falling <= 1'b0;
        end else begin
            falling <= next_falling;
            if (!falling && ground) begin
                direction <= next_direction;
            end
        end
    end

    // Output assignments
    assign walk_left = !falling && !direction;
    assign walk_right = !falling && direction;
    assign aaah = falling;

endmodule