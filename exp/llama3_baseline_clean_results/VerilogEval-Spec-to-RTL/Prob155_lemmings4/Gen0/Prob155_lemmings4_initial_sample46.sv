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

// Define the states
enum logic [3:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

// Counter for falling duration
logic [5:0] fall_counter;

// Internal signal for walking direction
logic walking_left;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 6'd0;
        walking_left <= 1'b1;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 6'd0;
        end
    end
end

always_comb begin
    next_state = state;
    walking_left = (state == WALK_LEFT || state == DIGGING) ? walking_left : ~walking_left;
    case (state)
        WALK_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
                walking_left = 1'b0;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
                walking_left = 1'b1;
            end
        end
        WALK_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
                walking_left = 1'b1;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
                walking_left = 1'b0;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 6'd20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = walking_left ? WALK_LEFT : WALK_RIGHT;
                end
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
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

always_comb begin
    walk_left = (state == WALK_LEFT) ? 1'b1 : (state == SPLATTERED) ? 1'b0 : walking_left;
    walk_right = (state == WALK_RIGHT) ? 1'b1 : (state == SPLATTERED) ? 1'b0 : ~walking_left;
    aaah = (state == FALLING) ? 1'b1 : 1'b0;
    digging = (state == DIGGING) ? 1'b1 : 1'b0;
end

endmodule