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

// Define the states
typedef enum logic [1:0] {
    WALKING_LEFT,
    WALKING_RIGHT,
    FALLING,
    DIGGING
} state_t;

// Current state
state_t current_state;
state_t next_state;

// Output logic
always_comb begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    case (current_state)
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

// State machine logic
always_comb begin
    next_state = current_state;
    case (current_state)
        WALKING_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALKING_RIGHT;
            end else if (bump_right) begin
                // Do nothing
            end
        end
        WALKING_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_right) begin
                next_state = WALKING_LEFT;
            end else if (bump_left) begin
                // Do nothing
            end
        end
        FALLING: begin
            if (ground) begin
                if (current_state == DIGGING) begin
                    next_state = WALKING_LEFT;
                end else if (current_state == WALKING_LEFT) begin
                    next_state = WALKING_LEFT;
                end else begin
                    next_state = WALKING_RIGHT;
                end
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALKING_LEFT;
    end else begin
        current_state <= next_state;
    end
end

endmodule