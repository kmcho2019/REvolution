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
enum logic [2:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

// Define the counter for fall time
logic [5:0] fall_time;

// Next state logic
always_comb begin
    next_state = state;
    case (state)
        WALK_LEFT: begin
            if (!ground) next_state = FALLING;
            else if (bump_left) next_state = WALK_RIGHT;
            else if (bump_right) next_state = WALK_LEFT;
            else if (dig) next_state = DIGGING;
        end
        WALK_RIGHT: begin
            if (!ground) next_state = FALLING;
            else if (bump_left) next_state = WALK_LEFT;
            else if (bump_right) next_state = WALK_RIGHT;
            else if (dig) next_state = DIGGING;
        end
        FALLING: begin
            if (ground) begin
                if (fall_time > 20) next_state = SPLATTERED;
                else if (state == FALLING) next_state = WALK_LEFT;
                else next_state = WALK_RIGHT;
            end
        end
        DIGGING: begin
            if (!ground) next_state = FALLING;
        end
        SPLATTERED: next_state = SPLATTERED;
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
        FALLING: aaah = 1;
        DIGGING: digging = 1;
        default: ;
    endcase
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_time <= 0;
    end
    else begin
        state <= next_state;
        if (state == FALLING) fall_time <= fall_time + 1;
        else fall_time <= 0;
    end
end

endmodule