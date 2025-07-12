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

typedef enum logic [1:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING
} state_t;

state_t state, next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    next_state = state;
    
    case (state)
        WALK_LEFT: begin
            walk_left = 1;
            if (!ground) begin
                aaah = 1;
                next_state = FALLING;
            end else if (dig) begin
                digging = 1;
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                if (bump_left && bump_right) begin
                    next_state = WALK_RIGHT;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end
            end
        end
        WALK_RIGHT: begin
            walk_right = 1;
            if (!ground) begin
                aaah = 1;
                next_state = FALLING;
            end else if (dig) begin
                digging = 1;
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                if (bump_left && bump_right) begin
                    next_state = WALK_LEFT;
                end else if (bump_left) begin
                    next_state = WALK_LEFT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end
            end
        end
        FALLING: begin
            aaah = 1;
            if (ground) begin
                if (state == WALK_LEFT) begin
                    next_state = WALK_LEFT;
                end else if (state == WALK_RIGHT) begin
                    next_state = WALK_RIGHT;
                end
            end
        end
        DIGGING: begin
            digging = 1;
            if (!ground) begin
                next_state = FALLING;
            end
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

endmodule