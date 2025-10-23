module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Define the states
enum logic [1:0] {IDLE_LEFT, IDLE_RIGHT, FALLING} state, next_state;

// Determine the current state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
    end else begin
        state <= next_state;
    end
end

// Determine the next state
always_comb begin
    next_state = state;
    case (state)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                next_state = IDLE_LEFT; // no change
            end
        end
        IDLE_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = IDLE_LEFT;
            end else if (bump_right) begin
                next_state = IDLE_LEFT; // switch direction
            end
        end
        FALLING: begin
            if (ground) begin
                next_state = (bump_left || bump_right) ? (state == IDLE_LEFT ? IDLE_RIGHT : IDLE_LEFT) : (state == IDLE_LEFT ? IDLE_LEFT : IDLE_RIGHT);
            end
        end
        default: next_state = IDLE_LEFT;
    endcase
end

// Determine the outputs
always_comb begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    case (state)
        IDLE_LEFT: walk_left = 1;
        IDLE_RIGHT: walk_right = 1;
        FALLING: aaah = 1;
        default: ;
    endcase
end

endmodule