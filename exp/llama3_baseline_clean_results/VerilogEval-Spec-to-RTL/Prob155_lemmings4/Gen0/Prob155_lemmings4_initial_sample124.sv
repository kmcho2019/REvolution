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

enum logic [2:0] {
    WALKING_LEFT,
    WALKING_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

logic [4:0] fall_count;
logic [4:0] next_fall_count;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING_LEFT;
        fall_count <= 5'b0;
    end else begin
        state <= next_state;
        fall_count <= next_fall_count;
    end
end

always_comb begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    next_state = state;
    next_fall_count = fall_count;

    case (state)
        WALKING_LEFT: begin
            walk_left = 1;
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALKING_RIGHT;
            end else if (bump_right) begin
                next_state = WALKING_LEFT;
            end
        end
        WALKING_RIGHT: begin
            walk_right = 1;
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_right) begin
                next_state = WALKING_LEFT;
            end else if (bump_left) begin
                next_state = WALKING_RIGHT;
            end
        end
        FALLING: begin
            aaah = 1;
            next_fall_count = fall_count + 1;
            if (ground) begin
                if (fall_count > 5'd20) begin
                    next_state = SPLATTERED;
                end else begin
                    if (state == WALKING_LEFT) begin
                        next_state = WALKING_LEFT;
                    end else begin
                        next_state = WALKING_RIGHT;
                    end
                end
            end
        end
        DIGGING: begin
            digging = 1;
            if (~ground) begin
                next_state = FALLING;
            end
        end
        SPLATTERED: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule