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

// Define the states
parameter IDLE_LEFT = 4'b0000;
parameter IDLE_RIGHT = 4'b0001;
parameter FALLING = 4'b0010;
parameter DIGGING_LEFT = 4'b0011;
parameter DIGGING_RIGHT = 4'b0100;
parameter DEAD = 4'b0101;

reg [3:0] state, next_state;
reg [4:0] fall_count, next_fall_count;
reg [3:0] original_direction, next_original_direction;

always @(*) begin
    next_state = state;
    next_fall_count = fall_count;
    next_original_direction = original_direction;

    case(state)
        IDLE_LEFT: begin
            if (bump_left) next_state = IDLE_RIGHT;
            else if (bump_right) next_state = IDLE_LEFT;
            if (!ground) next_state = FALLING;
            if (dig) next_state = DIGGING_LEFT;
        end
        IDLE_RIGHT: begin
            if (bump_left) next_state = IDLE_LEFT;
            else if (bump_right) next_state = IDLE_RIGHT;
            if (!ground) next_state = FALLING;
            if (dig) next_state = DIGGING_RIGHT;
        end
        FALLING: begin
            next_fall_count = fall_count + 1;
            if (ground) begin
                if (fall_count > 20) next_state = DEAD;
                else if (original_direction == IDLE_LEFT) next_state = IDLE_LEFT;
                else if (original_direction == IDLE_RIGHT) next_state = IDLE_RIGHT;
                next_fall_count = 0;
            end
        end
        DIGGING_LEFT: begin
            if (!ground) next_state = FALLING;
            next_original_direction = IDLE_LEFT;
        end
        DIGGING_RIGHT: begin
            if (!ground) next_state = FALLING;
            next_original_direction = IDLE_RIGHT;
        end
        DEAD: next_state = DEAD;
        default: next_state = IDLE_LEFT;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        fall_count <= 0;
        original_direction <= IDLE_LEFT;
    end
    else begin
        state <= next_state;
        fall_count <= next_fall_count;
        original_direction <= next_original_direction;
    end
end

always @(*) begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case(state)
        IDLE_LEFT: begin
            walk_left = 1;
        end
        IDLE_RIGHT: begin
            walk_right = 1;
        end
        FALLING: begin
            aaah = 1;
        end
        DIGGING_LEFT: begin
            digging = 1;
            walk_left = 1;
        end
        DIGGING_RIGHT: begin
            digging = 1;
            walk_right = 1;
        end
        default: ;
    endcase
end

endmodule