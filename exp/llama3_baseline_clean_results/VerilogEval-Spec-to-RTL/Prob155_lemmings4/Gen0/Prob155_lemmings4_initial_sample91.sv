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

// States
enum logic [2:0] {
    WALK_LEFT = 3'b001,
    WALK_RIGHT = 3'b010,
    FALLING = 3'b011,
    DIGGING = 3'b100,
    SPLATTERED = 3'b101
} state, next_state;

// Count the number of cycles the Lemming has fallen
logic [5:0] fall_count;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_count <= 0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_count <= fall_count + 1;
        end else begin
            fall_count <= 0;
        end
    end
end

always_comb begin
    next_state = state;
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1;
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1;
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end
        end
        FALLING: begin
            aaah = 1;
            if (ground) begin
                if (fall_count > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    if (state == FALLING) begin
                        if (bump_left) begin
                            next_state = WALK_RIGHT;
                        end else if (bump_right) begin
                            next_state = WALK_LEFT;
                        end else begin
                            if (state == FALLING) begin
                                if (fall_count == 1) begin
                                    if (dig) begin
                                        next_state = DIGGING;
                                    end else begin
                                        next_state = WALK_LEFT;
                                    end
                                end else begin
                                    next_state = WALK_LEFT;
                                end
                            end else begin
                                next_state = WALK_LEFT;
                            end
                        end
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end
            end
        end
        DIGGING: begin
            digging = 1;
            if (!ground) begin
                next_state = FALLING;
            end
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