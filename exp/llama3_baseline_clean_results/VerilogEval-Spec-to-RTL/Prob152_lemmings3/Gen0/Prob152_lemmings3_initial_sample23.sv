module TopModule(
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

enum logic [1:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING
} state, next_state;

logic [1:0] prev_direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        prev_direction <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    
    case (state)
        WALK_LEFT: begin
            walk_left = 1;
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1;
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        FALLING: begin
            aaah = 1;
            if (ground) begin
                if (prev_direction == WALK_LEFT) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            digging = 1;
            if (~ground) begin
                next_state = FALLING;
                if (prev_direction == WALK_LEFT) begin
                    prev_direction = WALK_LEFT;
                end else begin
                    prev_direction = WALK_RIGHT;
                end
            end else begin
                next_state = DIGGING;
            end
        end
        default: next_state = WALK_LEFT;
    endcase
    
    if (state == WALK_LEFT) begin
        prev_direction = WALK_LEFT;
    end else if (state == WALK_RIGHT) begin
        prev_direction = WALK_RIGHT;
    end
    
    if ((bump_left && bump_right) && (state == WALK_LEFT)) begin
        next_state = WALK_RIGHT;
    end else if ((bump_left && bump_right) && (state == WALK_RIGHT)) begin
        next_state = WALK_LEFT;
    end
end

endmodule