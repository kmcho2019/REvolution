`timescale 1ns/1ns

module TopModule (
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

// Define the states of the FSM
typedef enum logic [3:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state_type;

// Define the current state and next state
state_type current_state, next_state;

// Define a counter to count the number of clock cycles the Lemming is falling
reg [5:0] fall_counter;

// Define a flag to indicate the direction the Lemming was walking before falling
reg walk_direction;

// FSM logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset the FSM to the walking left state
        current_state <= WALK_LEFT;
        walk_direction <= 1'b1; // Walking left
        fall_counter <= 6'b0;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (current_state)
            WALK_LEFT: begin
                // Check if the Lemming hits an obstacle
                if (bump_left) begin
                    next_state <= WALK_RIGHT;
                    walk_direction <= 1'b0; // Walking right
                end else if (bump_right) begin
                    next_state <= WALK_LEFT;
                end else if (!ground) begin
                    next_state <= FALLING;
                    fall_counter <= 6'b1;
                end else if (dig) begin
                    next_state <= DIGGING;
                end else begin
                    next_state <= WALK_LEFT;
                end
                walk_left <= 1'b1;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
            WALK_RIGHT: begin
                // Check if the Lemming hits an obstacle
                if (bump_right) begin
                    next_state <= WALK_LEFT;
                    walk_direction <= 1'b1; // Walking left
                end else if (bump_left) begin
                    next_state <= WALK_RIGHT;
                end else if (!ground) begin
                    next_state <= FALLING;
                    fall_counter <= 6'b1;
                end else if (dig) begin
                    next_state <= DIGGING;
                end else begin
                    next_state <= WALK_RIGHT;
                end
                walk_left <= 1'b0;
                walk_right <= 1'b1;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
            FALLING: begin
                // Increment the fall counter
                fall_counter <= fall_counter + 6'b1;
                if (ground) begin
                    // Check if the Lemming has fallen for more than 20 clock cycles
                    if (fall_counter > 6'd20) begin
                        next_state <= SPLATTERED;
                    end else begin
                        // Resume walking in the same direction as before the fall
                        if (walk_direction) begin
                            next_state <= WALK_LEFT;
                        end else begin
                            next_state <= WALK_RIGHT;
                        end
                    end
                end else begin
                    next_state <= FALLING;
                end
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
                digging <= 1'b0;
            end
            DIGGING: begin
                // Check if the Lemming has reached the other side
                if (!ground) begin
                    next_state <= FALLING;
                    fall_counter <= 6'b1;
                end else begin
                    next_state <= DIGGING;
                end
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b1;
            end
            SPLATTERED: begin
                // The Lemming has splattered and ceased walking, falling, or digging
                next_state <= SPLATTERED;
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
            default: begin
                next_state <= WALK_LEFT;
            end
        endcase
        current_state <= next_state;
    end
end

endmodule