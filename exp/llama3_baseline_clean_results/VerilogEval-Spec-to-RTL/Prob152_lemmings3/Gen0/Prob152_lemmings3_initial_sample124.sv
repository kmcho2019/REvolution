module TopModule (
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

enum logic [1:0] {IDLE_LEFT, IDLE_RIGHT, FALLING, DIGGING} state, next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_right) begin
                next_state = IDLE_RIGHT;
            end else if (bump_left) begin
                next_state = IDLE_LEFT;
            end else begin
                next_state = IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = IDLE_LEFT;
            end else if (bump_right) begin
                next_state = IDLE_RIGHT;
            end else begin
                next_state = IDLE_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (next_state == DIGGING) begin
                    next_state = IDLE_LEFT;
                end else if (next_state == IDLE_RIGHT) begin
                    next_state = IDLE_RIGHT;
                end else begin
                    next_state = IDLE_LEFT;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = IDLE_LEFT;
            end
        end
        default: next_state = IDLE_LEFT;
    endcase
end

always_comb begin
    case (state)
        IDLE_LEFT: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        IDLE_RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        FALLING: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        DIGGING: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        default: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule