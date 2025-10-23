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

// State definitions
enum logic [2:0] {
    WALK_LEFT = 0,
    WALK_RIGHT = 1,
    FALL_LEFT = 2,
    FALL_RIGHT = 3,
    DIG_LEFT = 4,
    DIG_RIGHT = 5
} state, next_state;

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    next_state = state;

    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALL_LEFT;
            end else if (dig) begin
                next_state = DIG_LEFT;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end
        end

        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALL_RIGHT;
            end else if (dig) begin
                next_state = DIG_RIGHT;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end
        end

        FALL_LEFT: begin
            if (ground) begin
                next_state = WALK_LEFT;
            end
        end

        FALL_RIGHT: begin
            if (ground) begin
                next_state = WALK_RIGHT;
            end
        end

        DIG_LEFT: begin
            if (!ground) begin
                next_state = FALL_LEFT;
            end else if (!dig) begin
                next_state = WALK_LEFT;
            end
        end

        DIG_RIGHT: begin
            if (!ground) begin
                next_state = FALL_RIGHT;
            end else if (!dig) begin
                next_state = WALK_RIGHT;
            end
        end

        default: next_state = WALK_LEFT;
    endcase
end

// Output logic
always_comb begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case (state)
        WALK_LEFT: walk_left = 1;
        WALK_RIGHT: walk_right = 1;
        FALL_LEFT, FALL_RIGHT: aaah = 1;
        DIG_LEFT, DIG_RIGHT: digging = 1;
    endcase
end

endmodule