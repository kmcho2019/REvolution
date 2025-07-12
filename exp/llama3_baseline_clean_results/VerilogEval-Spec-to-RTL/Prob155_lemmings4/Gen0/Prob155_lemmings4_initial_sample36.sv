`define MAX_FALL_CYCLES 20

module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

enum {WALKING_LEFT, WALKING_RIGHT, FALLING, DIGGING, SPLATTERED} state, next_state;

reg [4:0] fall_cycles;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING_LEFT;
        fall_cycles <= 0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_cycles <= fall_cycles + 1;
        end else begin
            fall_cycles <= 0;
        end
    end
end

always @(*) begin
    case (state)
        WALKING_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALKING_RIGHT;
            end else if (bump_right) begin
                next_state = WALKING_LEFT;
            end else begin
                next_state = WALKING_LEFT;
            end
        end
        WALKING_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_right) begin
                next_state = WALKING_LEFT;
            end else if (bump_left) begin
                next_state = WALKING_RIGHT;
            end else begin
                next_state = WALKING_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_cycles > `MAX_FALL_CYCLES) begin
                    next_state = SPLATTERED;
                end else if (dig) begin
                    next_state = DIGGING;
                end else begin
                    next_state = WALKING_LEFT; // Default to WALKING_LEFT for simplicity
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            if (~ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
        default: next_state = WALKING_LEFT;
    endcase
end

always @(*) begin
    case (state)
        WALKING_LEFT: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        WALKING_RIGHT: begin
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
        SPLATTERED: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        default: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule