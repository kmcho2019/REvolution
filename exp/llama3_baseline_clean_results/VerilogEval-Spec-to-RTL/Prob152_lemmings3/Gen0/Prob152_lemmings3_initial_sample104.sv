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
typedef enum logic [1:0] {
    WALKING_LEFT,
    WALKING_RIGHT,
    FALLING,
    DIGGING
} state_t;

// Current state and next state
state_t current_state;
state_t next_state;

// Direction the Lemming was walking before it started falling or digging
logic [1:0] previous_state;

// Default values for outputs
assign walk_left = (current_state == WALKING_LEFT);
assign walk_right = (current_state == WALKING_RIGHT);
assign aaah = (current_state == FALLING);
assign digging = (current_state == DIGGING);

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
                next_state = WALKING_LEFT;
            end
        end
        WALKING_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALKING_LEFT;
            end else if (bump_right) begin
                next_state = WALKING_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (previous_state == WALKING_LEFT) begin
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
        default: next_state = WALKING_LEFT;
    endcase
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALKING_LEFT;
    end else begin
        case (current_state)
            WALKING_LEFT: begin
                if (bump_left || bump_right) begin
                    previous_state <= WALKING_LEFT;
                end
            end
            WALKING_RIGHT: begin
                if (bump_left || bump_right) begin
                    previous_state <= WALKING_RIGHT;
                end
            end
            FALLING: begin
                // No state update needed
            end
            DIGGING: begin
                // No state update needed
            end
            default: previous_state <= WALKING_LEFT;
        endcase
        current_state <= next_state;
    end
end

endmodule