module TopModule(
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

// Define the states
enum logic [1:0] {
    WALKING_LEFT,
    WALKING_RIGHT,
    FALLING,
    DIGGING
} state, next_state;

// Define the previous walking direction
logic [1:0] prev_direction;

// Combinational logic to determine the next state
always_comb begin
    next_state = state;
    case (state)
        WALKING_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALKING_RIGHT;
            end else if (bump_right) begin
                next_state = WALKING_LEFT;
            end
        end
        WALKING_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALKING_LEFT;
            end else if (bump_right) begin
                next_state = WALKING_LEFT;
            end
        end
        FALLING: begin
            if (ground) begin
                next_state = WALKING_LEFT;
                if (prev_direction == WALKING_RIGHT) begin
                    next_state = WALKING_RIGHT;
                end
            end
        end
        DIGGING: begin
            if (~ground) begin
                next_state = FALLING;
            end
        end
    endcase
end

// Sequential logic to update the state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING_LEFT;
        prev_direction <= WALKING_LEFT;
    end else begin
        state <= next_state;
        if (state == WALKING_LEFT || state == WALKING_RIGHT) begin
            prev_direction <= state;
        end
    end
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
    endcase
end

endmodule