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
enum logic [2:0] {
    IDLE_LEFT = 3'b001,
    IDLE_RIGHT = 3'b010,
    FALLING = 3'b011,
    DIGGING_LEFT = 3'b100,
    DIGGING_RIGHT = 3'b101
} state, next_state;

// Define the current walking direction
logic walking_left;

always_comb begin
    // Default next state is the current state
    next_state = state;

    case (state)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING_LEFT;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING_RIGHT;
            end else if (bump_left) begin
                next_state = IDLE_LEFT;
            end else if (bump_right) begin
                next_state = IDLE_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (walking_left) begin
                    next_state = IDLE_LEFT;
                end else begin
                    next_state = IDLE_RIGHT;
                end
            end
        end
        DIGGING_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING_LEFT;
            end
        end
        DIGGING_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING_RIGHT;
            end
        end
        default: begin
            next_state = IDLE_LEFT;
        end
    endcase
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        walking_left <= 1'b1;
    end else begin
        state <= next_state;
        case (next_state)
            IDLE_LEFT: begin
                walking_left <= 1'b1;
            end
            IDLE_RIGHT: begin
                walking_left <= 1'b0;
            end
            default: begin
                // No change in walking direction
            end
        endcase
    end
end

always_comb begin
    case (state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        IDLE_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        DIGGING_LEFT: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        DIGGING_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule