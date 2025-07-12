module TopModule (
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

// Enumerations for states
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
            else if (dig && ground) next_state = DIGGING;
            else if (bump_left) next_state = IDLE_RIGHT;
            else if (bump_right) next_state = IDLE_LEFT;
        end
        IDLE_RIGHT: begin
            if (!ground) next_state = FALLING;
            else if (dig && ground) next_state = DIGGING;
            else if (bump_left) next_state = IDLE_LEFT;
            else if (bump_right) next_state = IDLE_RIGHT;
        end
        FALLING: begin
            if (ground) next_state = IDLE_LEFT;
        end
        DIGGING: begin
            if (!ground) next_state = FALLING;
        end
    endcase
end

// Sequential logic for state transition
always @(posedge clk or posedge areset) begin
    if (areset) state <= IDLE_LEFT;
    else state <= next_state;
end

// Output logic
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
    endcase
end

endmodule