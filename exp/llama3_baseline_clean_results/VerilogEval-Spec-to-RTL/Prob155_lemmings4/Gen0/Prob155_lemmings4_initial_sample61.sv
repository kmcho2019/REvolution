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

// Define the states of the machine
typedef enum logic [3:0] {
    WALKING_LEFT,
    WALKING_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state_t;

// Define the current state and the next state
state_t current_state, next_state;

// Define the direction of the Lemming before it starts falling or digging
logic [1:0] direction;

// Define the counter for the number of clock cycles the Lemming has been falling
logic [5:0] fall_counter;

// Assign the outputs based on the current state
always_comb begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;
    
    case (current_state)
        WALKING_LEFT: begin
            walk_left = 1'b1;
        end
        WALKING_RIGHT: begin
            walk_right = 1'b1;
        end
        FALLING: begin
            aaah = 1'b1;
        end
        DIGGING: begin
            digging = 1'b1;
            if (direction == 2'b01) begin
                walk_left = 1'b1;
            end else begin
                walk_right = 1'b1;
            end
        end
        default: begin
            // SPLATTERED state, all outputs are 0
        end
    endcase
end

// Define the next state based on the current state and the input signals
always_comb begin
    next_state = current_state;
    
    case (current_state)
        WALKING_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
                direction = 2'b01; // left
            end else if (bump_right) begin
                next_state = WALKING_RIGHT;
            end else if (bump_left) begin
                next_state = WALKING_LEFT; // no change
            end
        end
        WALKING_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
                direction = 2'b10; // right
            end else if (bump_left) begin
                next_state = WALKING_LEFT;
            end else if (bump_right) begin
                next_state = WALKING_RIGHT; // no change
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    if (direction == 2'b01) begin
                        next_state = WALKING_LEFT;
                    end else begin
                        next_state = WALKING_RIGHT;
                    end
                end
            end
        end
        DIGGING: begin
            if (~ground) begin
                next_state = FALLING;
                fall_counter = 6'd0;
                if (direction == 2'b01) begin
                    walk_left = 1'b1;
                end else begin
                    walk_right = 1'b1;
                end
            end
        end
        default: begin
            // SPLATTERED state, no change
        end
    endcase
end

// Update the current state and the fall counter on the positive edge of the clock
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALKING_LEFT;
        fall_counter <= 6'd0;
    end else begin
        current_state <= next_state;
        if (current_state == FALLING) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 6'd0;
        end
    end
end

endmodule