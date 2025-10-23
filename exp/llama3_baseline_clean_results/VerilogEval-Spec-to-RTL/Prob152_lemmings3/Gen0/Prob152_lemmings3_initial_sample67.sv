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
enum logic [1:0] {WALK_LEFT, WALK_RIGHT, FALLING, DIGGING} state, next_state;

// Initialize the state
initial state = WALK_LEFT;

// Always block for sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always @* begin
    // Default values for outputs
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    // Determine the next state
    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
                walk_left = 0;
                aaah = 1;
            end else if (dig) begin
                next_state = DIGGING;
                digging = 1;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
                walk_left = 0;
                walk_right = 1;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
                walk_left = 1;
                walk_right = 0;
            end else begin
                next_state = WALK_LEFT;
                walk_left = 1;
                walk_right = 0;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
                walk_right = 0;
                aaah = 1;
            end else if (dig) begin
                next_state = DIGGING;
                digging = 1;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
                walk_right = 0;
                walk_left = 1;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
                walk_right = 1;
                walk_left = 0;
            end else begin
                next_state = WALK_RIGHT;
                walk_right = 1;
                walk_left = 0;
            end
        end
        FALLING: begin
            if (ground) begin
                // Check the previous state to determine the walking direction
                if (state == WALK_LEFT) begin
                    next_state = WALK_LEFT;
                    walk_left = 1;
                    walk_right = 0;
                end else if (state == WALK_RIGHT) begin
                    next_state = WALK_RIGHT;
                    walk_right = 1;
                    walk_left = 0;
                end else if (state == DIGGING) begin
                    // If the previous state was DIGGING, the Lemming was digging and then fell
                    // So, it should continue walking in the original direction
                    if (state == DIGGING) begin
                        next_state = WALK_LEFT;
                        walk_left = 1;
                        walk_right = 0;
                    end
                end
            end else begin
                next_state = FALLING;
                aaah = 1;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
                aaah = 1;
            end else begin
                next_state = DIGGING;
                digging = 1;
            end
        end
    endcase
end

endmodule