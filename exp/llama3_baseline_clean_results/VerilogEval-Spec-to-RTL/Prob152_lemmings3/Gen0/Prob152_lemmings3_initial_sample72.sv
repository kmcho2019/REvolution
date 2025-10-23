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
enum logic [1:0] {
    IDLE_LEFT,
    IDLE_RIGHT,
    FALLING,
    DIGGING
} state, next_state;

// Combinational logic for next state
always_comb begin
    next_state = state;
    case (state)
        IDLE_LEFT: begin
            if (!ground) next_state = FALLING;
            else if (dig) next_state = DIGGING;
            else if (bump_left) next_state = IDLE_RIGHT;
            else if (bump_right) next_state = IDLE_LEFT;
        end
        IDLE_RIGHT: begin
            if (!ground) next_state = FALLING;
            else if (dig) next_state = DIGGING;
            else if (bump_left) next_state = IDLE_LEFT;
            else if (bump_right) next_state = IDLE_RIGHT;
        end
        FALLING: begin
            if (ground) next_state = IDLE_LEFT;
        end
        DIGGING: begin
            if (!ground) next_state = FALLING;
        end
        default: next_state = IDLE_LEFT;
    endcase
end

// Sequential logic for state register
always @(posedge clk or posedge areset) begin
    if (areset) state <= IDLE_LEFT;
    else state <= next_state;
end

// Output logic
always_comb begin
    walk_left = (state == IDLE_LEFT);
    walk_right = (state == IDLE_RIGHT);
    aaah = (state == FALLING);
    digging = (state == DIGGING);
end

endmodule