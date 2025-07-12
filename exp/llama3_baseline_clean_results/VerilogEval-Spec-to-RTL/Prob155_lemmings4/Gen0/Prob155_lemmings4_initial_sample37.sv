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

// State and direction enumeration
enum logic [1:0] {WALKING, FALLING, DIGGING, SPLATTERED, RESET} state, next_state;
enum logic {LEFT, RIGHT} direction, next_direction;

// Counter for falling clock cycles
logic [4:0] fall_counter, next_fall_counter;

// Output signals
assign walk_left = (state == WALKING && direction == LEFT) || (state == DIGGING && direction == LEFT);
assign walk_right = (state == WALKING && direction == RIGHT) || (state == DIGGING && direction == RIGHT);
assign aaah = state == FALLING;
assign digging = state == DIGGING;

// Next state and direction logic
always_comb begin
    next_state = state;
    next_direction = direction;
    next_fall_counter = fall_counter;

    case (state)
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
                next_fall_counter = 0;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_direction = RIGHT;
            end else if (bump_right) begin
                next_direction = LEFT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = WALKING;
                end
            end else begin
                next_fall_counter = fall_counter + 1;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
                next_fall_counter = 0;
            end
        end
        SPLATTERED: begin
            // Do nothing
        end
        default: begin
            next_state = WALKING;
            next_direction = LEFT;
        end
    endcase
end

// State and direction registers
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        direction <= LEFT;
        fall_counter <= 0;
    end else begin
        state <= next_state;
        direction <= next_direction;
        fall_counter <= next_fall_counter;
    end
end

endmodule