module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Enum for states
enum logic [1:0] {
    WALKING_LEFT = 2'b00,
    WALKING_RIGHT = 2'b01,
    FALLING = 2'b10,
    DIGGING = 2'b11
} state, next_state;

// Next state logic
always_comb begin
    case (state)
        WALKING_LEFT: begin
            if (!ground) next_state = FALLING;
            else if (dig) next_state = DIGGING;
            else if (bump_left) next_state = WALKING_RIGHT;
            else if (bump_right) next_state = WALKING_LEFT;
            else next_state = WALKING_LEFT;
        end
        WALKING_RIGHT: begin
            if (!ground) next_state = FALLING;
            else if (dig) next_state = DIGGING;
            else if (bump_left) next_state = WALKING_LEFT;
            else if (bump_right) next_state = WALKING_LEFT;
            else next_state = WALKING_RIGHT;
        end
        FALLING: begin
            if (ground) next_state = WALKING_LEFT;
            else next_state = FALLING;
        end
        DIGGING: begin
            if (!ground) next_state = FALLING;
            else next_state = DIGGING;
        end
        default: next_state = WALKING_LEFT;
    endcase
end

// Output logic
always_comb begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    case (state)
        WALKING_LEFT: begin
            walk_left = 1;
        end
        WALKING_RIGHT: begin
            walk_right = 1;
        end
        FALLING: begin
            aaah = 1;
        end
        DIGGING: begin
            digging = 1;
        end
        default: ;
    endcase
end

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) state <= WALKING_LEFT;
    else state <= next_state;
end

endmodule