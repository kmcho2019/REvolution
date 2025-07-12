module TopModule(
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

typedef enum logic [1:0] {
    WALKING,
    FALLING,
    DIGGING,
    SPLATTERED
} state_t;

typedef enum logic {
    LEFT,
    RIGHT
} direction_t;

state_t state;
state_t next_state;
direction_t direction;
logic [4:0] fall_count;

always_comb begin
    case (state)
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                next_state = WALKING;
            end else begin
                next_state = WALKING;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_count > 5'd20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = WALKING;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
    endcase

    case (state)
        WALKING: begin
            if (bump_left) begin
                direction = RIGHT;
            end else if (bump_right) begin
                direction = LEFT;
            end
        end
        FALLING: begin
            // direction remains the same while falling
        end
        DIGGING: begin
            // direction remains the same while digging
        end
        SPLATTERED: begin
            // direction is irrelevant when splattered
        end
    endcase

    walk_left = (state == WALKING && direction == LEFT);
    walk_right = (state == WALKING && direction == RIGHT);
    aaah = (state == FALLING);
    digging = (state == DIGGING);
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        direction <= LEFT;
        fall_count <= 5'b0;
    end else begin
        state <= next_state;
        if (state == FALLING && !ground) begin
            fall_count <= fall_count + 1'b1;
        end else begin
            fall_count <= 5'b0;
        end
    end
end

endmodule