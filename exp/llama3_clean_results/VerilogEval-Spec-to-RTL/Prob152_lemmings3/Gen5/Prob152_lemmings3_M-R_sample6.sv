module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg walking;
reg falling;
reg digging_state;
reg prev_walk_direction;
reg walk_left_inner;
reg walk_right_inner;

assign walk_left = walking && walk_left_inner;
assign walk_right = walking && walk_right_inner;
assign aaah = falling;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walking <= 1'b1;
        falling <= 1'b0;
        digging_state <= 1'b0;
        prev_walk_direction <= 1'b0;
        walk_left_inner <= 1'b1;
        walk_right_inner <= 1'b0;
    end else begin
        if (!ground && walking) begin
            walking <= 1'b0;
            falling <= 1'b1;
            prev_walk_direction <= walk_left_inner;
        end else if (ground && falling) begin
            walking <= 1'b1;
            falling <= 1'b0;
            walk_left_inner <= prev_walk_direction;
            walk_right_inner <= ~prev_walk_direction;
        end else if (dig && walking && ground) begin
            walking <= 1'b0;
            digging_state <= 1'b1;
        end else if (!ground && digging_state) begin
            digging_state <= 1'b0;
            falling <= 1'b1;
            prev_walk_direction <= walk_left_inner;
        end

        if (bump_left && walking && !digging_state) begin
            walk_left_inner <= 1'b0;
            walk_right_inner <= 1'b1;
        end else if (bump_right && walking && !digging_state) begin
            walk_left_inner <= 1'b1;
            walk_right_inner <= 1'b0;
        end

        if (bump_left && bump_right && walking && !digging_state) begin
            walk_left_inner <= ~walk_left_inner;
            walk_right_inner <= ~walk_right_inner;
        end
    end
end

assign digging = digging_state;

endmodule