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
enum logic [1:0] {WALK_LEFT, WALK_RIGHT, FALLING} state, next_state;

// Define the direction
logic [1:0] direction, next_direction;

// Initialize the state and direction
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        direction <= 0; // 0: left, 1: right
    end else begin
        state <= next_state;
        direction <= next_direction;
    end
end

// Determine the next state and direction
always_comb begin
    next_state = state;
    next_direction = direction;

    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
                next_direction = 1; // right
            end else if (bump_right) begin
                // No change
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                // No change
            end else if (bump_right) begin
                next_state = WALK_LEFT;
                next_direction = 0; // left
            end
        end
        FALLING: begin
            if (ground) begin
                if (direction == 0) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
        end
    endcase
end

// Determine the output signals
always_comb begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1;
        end
        WALK_RIGHT: begin
            walk_right = 1;
        end
        FALLING: begin
            aaah = 1;
        end
    endcase
end

endmodule