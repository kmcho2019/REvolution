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

// Enumerate the states
enum logic [2:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING_LEFT,
    DIGGING_RIGHT
} state, next_state;

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state <= FALLING;
            end else if (dig) begin
                next_state <= DIGGING_LEFT;
            end else if (bump_left) begin
                next_state <= WALK_RIGHT;
            end else if (bump_right) begin
                next_state <= WALK_LEFT;
            end else begin
                next_state <= WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state <= FALLING;
            end else if (dig) begin
                next_state <= DIGGING_RIGHT;
            end else if (bump_left) begin
                next_state <= WALK_LEFT;
            end else if (bump_right) begin
                next_state <= WALK_LEFT;
            end else begin
                next_state <= WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (bump_left && bump_right) begin
                    if (dig) begin
                        next_state <= DIGGING_LEFT;
                    end else begin
                        next_state <= WALK_LEFT;
                    end
                end else if (dig) begin
                    if (bump_left) begin
                        next_state <= DIGGING_RIGHT;
                    end else begin
                        next_state <= DIGGING_LEFT;
                    end
                end else if (bump_left) begin
                    next_state <= WALK_RIGHT;
                end else if (bump_right) begin
                    next_state <= WALK_LEFT;
                end else begin
                    if (state == WALK_LEFT) begin
                        next_state <= WALK_LEFT;
                    end else if (state == WALK_RIGHT) begin
                        next_state <= WALK_RIGHT;
                    end else if (state == DIGGING_LEFT) begin
                        next_state <= WALK_LEFT;
                    end else if (state == DIGGING_RIGHT) begin
                        next_state <= WALK_RIGHT;
                    end
                end
            end else begin
                next_state <= FALLING;
            end
        end
        DIGGING_LEFT: begin
            if (!ground) begin
                next_state <= FALLING;
            end else begin
                next_state <= DIGGING_LEFT;
            end
        end
        DIGGING_RIGHT: begin
            if (!ground) begin
                next_state <= FALLING;
            end else begin
                next_state <= DIGGING_RIGHT;
            end
        end
        default: begin
            next_state <= WALK_LEFT;
        end
    endcase
end

// Output logic
always @(*) begin
    case (state)
        WALK_LEFT: begin
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end
        WALK_RIGHT: begin
            walk_left <= 0;
            walk_right <= 1;
            aaah <= 0;
            digging <= 0;
        end
        FALLING: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 1;
            digging <= 0;
        end
        DIGGING_LEFT: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
            digging <= 1;
        end
        DIGGING_RIGHT: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
            digging <= 1;
        end
        default: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end
    endcase
end

endmodule