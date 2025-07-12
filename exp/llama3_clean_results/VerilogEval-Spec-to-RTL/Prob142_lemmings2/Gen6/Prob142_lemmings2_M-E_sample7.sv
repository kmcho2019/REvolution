module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg direction; // 0 for left, 1 for right
reg state; // 0 for walking, 1 for falling
reg prev_state;

always @(*) begin
    if (state == 1'b0) begin // walking
        if (ground == 1'b0) begin
            next_state = 1'b1; // falling
        end else if (bump_left == 1'b1 && bump_right == 1'b1) begin
            next_state = 1'b0; // walking, change direction
        end else if (bump_left == 1'b1) begin
            next_state = 1'b0; // walking, change direction
        end else if (bump_right == 1'b1) begin
            next_state = 1'b0; // walking, change direction
        end else begin
            next_state = 1'b0; // still walking
        end
    end else begin // falling
        if (ground == 1'b1) begin
            next_state = 1'b0; // walking
        end else begin
            next_state = 1'b1; // still falling
        end
    end
end

always @(*) begin
    if (next_state == 1'b0 && prev_state == 1'b1) begin // resumed walking
        if (direction == 1'b0) begin // was walking left
            next_direction = 1'b0; // resume walking left
        end else begin // was walking right
            next_direction = 1'b1; // resume walking right
        end
    end else if (bump_left == 1'b1 && bump_right == 1'b1) begin
        if (direction == 1'b0) begin // walking left
            next_direction = 1'b1; // change direction to right
        end else begin // walking right
            next_direction = 1'b0; // change direction to left
        end
    end else if (bump_left == 1'b1) begin
        next_direction = 1'b1; // change direction to right
    end else if (bump_right == 1'b1) begin
        next_direction = 1'b0; // change direction to left
    end else begin
        next_direction = direction; // no change
    end
end

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        direction <= 1'b0; // reset to walking left
        state <= 1'b0; // reset to walking
        prev_state <= 1'b0; // reset to walking
        walk_left <= 1'b1; // reset to walking left
        walk_right <= 1'b0; // reset to walking left
        aaah <= 1'b0; // reset to not falling
    end else begin
        direction <= next_direction;
        state <= next_state;
        prev_state <= state;
        if (state == 1'b0) begin // walking
            if (direction == 1'b0) begin // walking left
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end else begin // walking right
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end
            aaah <= 1'b0;
        end else begin // falling
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
        end
    end
end

endmodule