module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// States
enum logic [1:0] {
    IDLE_LEFT,
    IDLE_RIGHT,
    FALLING,
    DIGGING_LEFT,
    DIGGING_RIGHT
} state, next_state;

always @(*) begin
    // Default values
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case (state)
        IDLE_LEFT: begin
            walk_left = 1;
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING_LEFT;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                next_state = IDLE_RIGHT;
            end else begin
                next_state = IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            walk_right = 1;
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING_RIGHT;
            end else if (bump_left) begin
                next_state = IDLE_LEFT;
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
            end else begin
                next_state = IDLE_RIGHT;
            end
        end
        FALLING: begin
            aaah = 1;
            if (ground) begin
                if (state == FALLING) begin
                    if (walk_left == 1) begin
                        next_state = IDLE_LEFT;
                    end else begin
                        next_state = IDLE_RIGHT;
                    end
                end else begin
                    next_state = state;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING_LEFT: begin
            digging = 1;
            walk_left = 1;
            if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING_LEFT;
            end
        end
        DIGGING_RIGHT: begin
            digging = 1;
            walk_right = 1;
            if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING_RIGHT;
            end
        end
        default: next_state = IDLE_LEFT;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state = IDLE_LEFT;
        walk_left = 1;
        walk_right = 0;
        aaah = 0;
        digging = 0;
    end else begin
        state = next_state;
    end
end

endmodule