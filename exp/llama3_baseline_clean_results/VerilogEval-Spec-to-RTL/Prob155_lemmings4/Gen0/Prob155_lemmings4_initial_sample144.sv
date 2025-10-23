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

// Define the states of the state machine
typedef enum logic [2:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state_type;

// Define the current state and the next state
state_type current_state;
state_type next_state;

// Define the counter for the number of clock cycles the Lemming has been falling
logic [5:0] fall_counter;

// Define the direction of the Lemming
logic walk_dir;

// Define the output signals
assign walk_left = current_state == WALK_LEFT &&!current_state == SPLATTERED;
assign walk_right = current_state == WALK_RIGHT &&!current_state == SPLATTERED;
assign aaah = current_state == FALLING;
assign digging = current_state == DIGGING;

// Define the sequential logic for the state machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset the state machine to the WALK_LEFT state
        current_state <= WALK_LEFT;
        fall_counter <= 6'd0;
        walk_dir <= 1'b1;
    end else begin
        // Update the current state and the fall counter
        current_state <= next_state;
        if (current_state == FALLING) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 6'd0;
        end
    end
end

// Define the combinational logic for the state machine
always @* begin
    // Define the default next state as the current state
    next_state = current_state;

    // Handle the state transitions
    case (current_state)
        WALK_LEFT: begin
            if (bump_left) begin
                // Switch direction when hitting an obstacle on the left
                next_state = WALK_RIGHT;
                walk_dir <= 1'b0;
            end else if (bump_right) begin
                // Do nothing when hitting an obstacle on the right
            end else if (!ground) begin
                // Fall when the ground disappears
                next_state = FALLING;
            end else if (dig) begin
                // Dig when the dig signal is asserted
                next_state = DIGGING;
            end
        end
        WALK_RIGHT: begin
            if (bump_right) begin
                // Switch direction when hitting an obstacle on the right
                next_state = WALK_LEFT;
                walk_dir <= 1'b1;
            end else if (bump_left) begin
                // Do nothing when hitting an obstacle on the left
            end else if (!ground) begin
                // Fall when the ground disappears
                next_state = FALLING;
            end else if (dig) begin
                // Dig when the dig signal is asserted
                next_state = DIGGING;
            end
        end
        FALLING: begin
            if (ground) begin
                // Resume walking when the ground reappears
                if (fall_counter > 20) begin
                    // Splatter if the Lemming has been falling for more than 20 clock cycles
                    next_state = SPLATTERED;
                end else if (walk_dir) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
        end
        DIGGING: begin
            if (!ground) begin
                // Fall when the ground disappears
                next_state = FALLING;
            end
        end
        SPLATTERED: begin
            // Do nothing when the Lemming has splattered
        end
    endcase
end

endmodule