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
typedef enum {
    walking_left,
    walking_right,
    falling,
    digging_state
} state;

// Current and next states
state current_state, next_state;

// Previous state (before falling or digging)
state previous_state;

always @(*) begin
    // Default next state is the current state
    next_state = current_state;

    // Determine the next state
    case (current_state)
        walking_left: begin
            if (!ground) begin
                next_state = falling;
            end else if (bump_left) begin
                next_state = walking_right;
            end else if (bump_right) begin
                next_state = walking_left;
            end else if (dig) begin
                next_state = digging_state;
            end
        end
        walking_right: begin
            if (!ground) begin
                next_state = falling;
            end else if (bump_left) begin
                next_state = walking_left;
            end else if (bump_right) begin
                next_state = walking_left;
            end else if (dig) begin
                next_state = digging_state;
            end
        end
        falling: begin
            if (ground) begin
                next_state = previous_state;
            end
        end
        digging_state: begin
            if (!ground) begin
                next_state = falling;
            end else if (bump_left || bump_right) begin
                // No effect
            end else if (dig) begin
                // Continue digging
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= walking_left;
        previous_state <= walking_left;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        // Update the current state
        current_state <= next_state;

        // Update the output signals
        case (current_state)
            walking_left: begin
                walk_left <= 1;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
            walking_right: begin
                walk_left <= 0;
                walk_right <= 1;
                aaah <= 0;
                digging <= 0;
            end
            falling: begin
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 1;
                digging <= 0;
            end
            digging_state: begin
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 1;
            end
        endcase

        // Update the previous state
        if (current_state == falling || current_state == digging_state) begin
            previous_state <= previous_state;
        end else begin
            previous_state <= current_state;
        end
    end
end
endmodule