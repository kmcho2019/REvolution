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

// Define the states
typedef enum logic [2:0] {
    WALKING_LEFT,
    WALKING_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state_t;

// Current state
state_t current_state;
state_t next_state;

// Original direction
state_t original_direction;

// Counter for falling clock cycles
reg [5:0] falling_counter;

// Output signals
always_comb begin
    walk_left = (current_state == WALKING_LEFT) || (current_state == DIGGING && original_direction == WALKING_LEFT);
    walk_right = (current_state == WALKING_RIGHT) || (current_state == DIGGING && original_direction == WALKING_RIGHT);
    aaah = (current_state == FALLING);
    digging = (current_state == DIGGING);
end

// Next state logic
always_comb begin
    case (current_state)
        WALKING_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
                original_direction = WALKING_LEFT;
            end else if (bump_left) begin
                next_state = WALKING_RIGHT;
            end else if (bump_right) begin
                next_state = WALKING_LEFT;
            end else begin
                next_state = WALKING_LEFT;
            end
        end
        WALKING_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
                original_direction = WALKING_RIGHT;
            end else if (bump_right) begin
                next_state = WALKING_LEFT;
            end else if (bump_left) begin
                next_state = WALKING_RIGHT;
            end else begin
                next_state = WALKING_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (falling_counter > 20) begin
                    next_state = SPLATTERED;
                end else if (original_direction == WALKING_LEFT) begin
                    next_state = WALKING_LEFT;
                end else begin
                    next_state = WALKING_RIGHT;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
                original_direction = WALKING_LEFT;
            end else begin
                next_state = DIGGING;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
        default: begin
            next_state = WALKING_LEFT;
        end
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALKING_LEFT;
        falling_counter <= 0;
        original_direction <= WALKING_LEFT;
    end else begin
        current_state <= next_state;
        if (current_state == FALLING) begin
            falling_counter <= falling_counter + 1;
        end else begin
            falling_counter <= 0;
        end
    end
end

endmodule