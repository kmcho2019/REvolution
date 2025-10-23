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

// Enum for states
enum {IDLE_LEFT, IDLE_RIGHT, FALLING, DIGGING_LEFT, DIGGING_RIGHT} state, next_state;

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state <= FALLING;
            end else if (dig) begin
                next_state <= DIGGING_LEFT;
            end else if (bump_left) begin
                next_state <= IDLE_RIGHT;
            end else if (bump_right) begin
                next_state <= IDLE_LEFT;
            end else begin
                next_state <= IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            if (!ground) begin
                next_state <= FALLING;
            end else if (dig) begin
                next_state <= DIGGING_RIGHT;
            end else if (bump_left) begin
                next_state <= IDLE_LEFT;
            end else if (bump_right) begin
                next_state <= IDLE_RIGHT;
            end else begin
                next_state <= IDLE_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (bump_left && bump_right) begin
                    next_state <= IDLE_LEFT;
                end else if (bump_left) begin
                    next_state <= IDLE_RIGHT;
                end else if (bump_right) begin
                    next_state <= IDLE_LEFT;
                end else begin
                    if (state == FALLING) begin
                        if (next_state == IDLE_LEFT) begin
                            next_state <= IDLE_LEFT;
                        end else begin
                            next_state <= IDLE_RIGHT;
                        end
                    end else if (state == IDLE_LEFT) begin
                        next_state <= IDLE_LEFT;
                    end else begin
                        next_state <= IDLE_RIGHT;
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
            next_state <= IDLE_LEFT;
        end
    endcase
end

// Output logic
always @(*) begin
    case (state)
        IDLE_LEFT: begin
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end
        IDLE_RIGHT: begin
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
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 1;
        end
        DIGGING_RIGHT: begin
            walk_left <= 0;
            walk_right <= 1;
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