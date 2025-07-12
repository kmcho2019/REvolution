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

    // State machine states
    parameter WALK_LEFT = 0;
    parameter WALK_RIGHT = 1;
    parameter FALLING = 2;
    parameter DIGGING = 3;
    parameter SPLATTERED = 4;

    // Current state
    reg [2:0] current_state;
    reg [2:0] next_state;

    // Counter for falling time
    reg [5:0] fall_counter;
    reg [5:0] next_fall_counter;

    // Previous ground value
    reg prev_ground;

    // Walking direction (0 for left, 1 for right)
    reg walk_direction;
    reg next_walk_direction;

    always @(*) begin
        // Initialize next state and fall counter
        next_state = current_state;
        next_fall_counter = fall_counter;
        next_walk_direction = walk_direction;

        // Determine next state and outputs
        case (current_state)
            WALK_LEFT: begin
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
                digging = 0;

                // If bumped, switch direction
                if (bump_right) begin
                    next_walk_direction = 1;
                    next_state = WALK_RIGHT;
                end
                // If no ground, start falling
                else if (!ground) begin
                    next_state = FALLING;
                end
                // If digging, start digging
                else if (dig) begin
                    next_state = DIGGING;
                end
            end
            WALK_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                aaah = 0;
                digging = 0;

                // If bumped, switch direction
                if (bump_left) begin
                    next_walk_direction = 0;
                    next_state = WALK_LEFT;
                end
                // If no ground, start falling
                else if (!ground) begin
                    next_state = FALLING;
                end
                // If digging, start digging
                else if (dig) begin
                    next_state = DIGGING;
                end
            end
            FALLING: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;

                // Increment fall counter
                next_fall_counter = fall_counter + 1;

                // If ground appears, resume walking
                if (ground) begin
                    // If fall counter exceeds 20, splatter
                    if (fall_counter > 20) begin
                        next_state = SPLATTERED;
                    end else begin
                        next_state = walk_direction ? WALK_RIGHT : WALK_LEFT;
                    end
                end
            end
            DIGGING: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 1;

                // If no ground, start falling
                if (!ground) begin
                    next_state = FALLING;
                end
            end
            SPLATTERED: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;

                // Stay in splattered state forever
            end
            default: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            fall_counter <= 0;
            walk_direction <= 0;
            prev_ground <= 1;
        end else begin
            current_state <= next_state;
            fall_counter <= next_fall_counter;
            walk_direction <= next_walk_direction;
            prev_ground <= ground;
        end
    end
endmodule