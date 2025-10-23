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
enum logic [1:0] {WALK, FALL, DIG} state, next_state;

// Define the direction
enum logic {LEFT, RIGHT} direction, next_direction;

always @(*) begin
    // Default next state and direction
    next_state = state;
    next_direction = direction;

    // Output logic
    walk_left = (state == WALK && direction == LEFT);
    walk_right = (state == WALK && direction == RIGHT);
    aaah = (state == FALL);
    digging = (state == DIG);

    case (state)
        WALK: begin
            // If no ground, start falling
            if (!ground) begin
                next_state = FALL;
            end
            // If told to dig, start digging
            else if (dig) begin
                next_state = DIG;
            end
            // If bumped, switch directions
            else if (bump_left && bump_right) begin
                next_direction = (direction == LEFT) ? RIGHT : LEFT;
            end
            else if (bump_left) begin
                next_direction = RIGHT;
            end
            else if (bump_right) begin
                next_direction = LEFT;
            end
        end
        FALL: begin
            // If ground reappears, resume walking
            if (ground) begin
                next_state = WALK;
            end
        end
        DIG: begin
            // If no ground, start falling
            if (!ground) begin
                next_state = FALL;
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK;
        direction <= LEFT;
    end
    else begin
        state <= next_state;
        direction <= next_direction;
    end
end

endmodule