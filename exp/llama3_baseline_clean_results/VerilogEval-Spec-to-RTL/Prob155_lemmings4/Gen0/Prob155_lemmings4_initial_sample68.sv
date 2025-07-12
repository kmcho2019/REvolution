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

// States
enum logic [2:0] {
    IDLE_LEFT,
    IDLE_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

// Registers
logic [4:0] fall_count;
logic direction; // 1 for left, 0 for right

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        direction <= 1;
        fall_count <= 5'd0;
    end else begin
        state <= next_state;
        if ((state == IDLE_LEFT || state == IDLE_RIGHT) && ~ground) begin
            fall_count <= 5'd1;
        end else if (state == FALLING && ground) begin
            fall_count <= 5'd0;
        end else if (state == FALLING) begin
            fall_count <= fall_count + 5'd1;
        end else begin
            fall_count <= 5'd0;
        end
    end
end

always_comb begin
    next_state = state;
    case (state)
        IDLE_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
                direction = 0;
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
                direction = 1;
            end
        end
        IDLE_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = IDLE_LEFT;
                direction = 1;
            end else if (bump_right) begin
                next_state = IDLE_RIGHT;
                direction = 0;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_count > 5'd20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = IDLE_LEFT;
                    if (direction == 0) begin
                        next_state = IDLE_RIGHT;
                    end
                end
            end
        end
        DIGGING: begin
            if (~ground) begin
                next_state = FALLING;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
    endcase
end

always_comb begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    case (state)
        IDLE_LEFT: begin
            walk_left = 1;
        end
        IDLE_RIGHT: begin
            walk_right = 1;
        end
        FALLING: begin
            aaah = 1;
        end
        DIGGING: begin
            digging = 1;
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