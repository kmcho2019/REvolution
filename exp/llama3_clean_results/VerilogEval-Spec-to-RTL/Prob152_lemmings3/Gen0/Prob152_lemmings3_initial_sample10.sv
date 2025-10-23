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

// Define states
enum logic [1:0] {WALK_LEFT, WALK_RIGHT, FALLING, DIGGING} state, next_state;

// Define direction register to keep track of walking direction
reg direction; // 1 for right, 0 for left

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        direction <= 1'b0; // default direction is left
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig && !bump_left && !bump_right) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
                direction = 1'b1; // update direction
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig && !bump_left && !bump_right) begin
                next_state = DIGGING;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
                direction = 1'b0; // update direction
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (direction) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
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
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

always @(*) begin
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        WALK_RIGHT: begin
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
        DIGGING: begin
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