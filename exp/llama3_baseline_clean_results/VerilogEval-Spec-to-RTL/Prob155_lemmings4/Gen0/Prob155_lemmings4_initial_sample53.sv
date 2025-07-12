module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [4:0] fall_count;
reg [1:0] direction; // 0: left, 1: right, 2: idle (falling or splattered)
reg falling;
reg digging_reg;
reg splattered;

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 0;
        fall_count <= 0;
        falling <= 0;
        digging_reg <= 0;
        splattered <= 0;
    end else begin
        if (splattered) begin
            // do nothing
        end else if (~ground && !falling) begin
            // start falling
            falling <= 1;
            fall_count <= 1;
        end else if (~ground && falling) begin
            // continue falling
            fall_count <= fall_count + 1;
        end else if (ground && falling) begin
            // hit ground after falling
            if (fall_count > 20) begin
                // splatter
                splattered <= 1;
            end
            falling <= 0;
            fall_count <= 0;
        end else if (dig && direction != 2 && ground) begin
            // start digging
            digging_reg <= 1;
        end else if (digging_reg && ~ground) begin
            // stop digging and start falling
            digging_reg <= 0;
            falling <= 1;
            fall_count <= 1;
        end else if (bump_left && direction == 0) begin
            // bump while walking left, switch to right
            direction <= 1;
        end else if (bump_right && direction == 1) begin
            // bump while walking right, switch to left
            direction <= 0;
        end else if (bump_left && bump_right && direction != 2) begin
            // bump both sides, switch direction
            direction <= ~direction;
        end
    end
end

always @ (*) begin
    walk_left = (direction == 0 && !splattered && !falling && !digging_reg);
    walk_right = (direction == 1 && !splattered && !falling && !digging_reg);
    aaah = falling;
    digging = digging_reg;
end

endmodule