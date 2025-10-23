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

reg walking_direction; // 1 for right, 0 for left
reg [1:0] state, next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // IDLE
        walking_direction <= 0; // WALK_LEFT
    end else begin
        state <= next_state;
        if (next_state == 2'b10) begin // FALLING
            // No change in walking direction while falling
        end else if (next_state == 2'b00) begin // IDLE
            if (digging) begin
                // No change in walking direction while digging
            end else if (bump_left || bump_right) begin
                walking_direction <= ~walking_direction; // Switch direction
            end
        end
    end
end

always_comb begin
    next_state = state;
    case (state)
        2'b00: begin // IDLE
            if (!ground) begin
                next_state = 2'b10; // FALLING
            end else if (dig) begin
                next_state = 2'b11; // DIGGING
            end else if (bump_left || bump_right) begin
                // Switch direction
            end
        end
        2'b10: begin // FALLING
            if (ground) begin
                next_state = 2'b00; // IDLE
            end
        end
        2'b11: begin // DIGGING
            if (!ground) begin
                next_state = 2'b10; // FALLING
            end
        end
    endcase
end

always_comb begin
    walk_left = (state == 2'b00 &&!walking_direction);
    walk_right = (state == 2'b00 && walking_direction);
    aaah = (state == 2'b10);
    digging = (state == 2'b11);
end

endmodule