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

// Define the states
localparam WALK_LEFT = 2'b00;
localparam WALK_RIGHT = 2'b01;
localparam FALLING = 2'b10;
localparam DIGGING = 2'b11;

// Define the current state and next state
reg [1:0] current_state, next_state;

// Define the fall counter
reg [5:0] fall_counter;

// Combinatorial logic for next state and outputs
always @(*) begin
    // Initialize next state to current state
    next_state = current_state;
    
    // Initialize outputs to 0
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    
    case (current_state)
        WALK_LEFT: begin
            // If ground disappears, transition to falling state
            if (!ground) begin
                next_state = FALLING;
                aaah = 1;
            end
            // If dig is 1, transition to digging state
            else if (dig && ground) begin
                next_state = DIGGING;
                digging = 1;
            end
            // If bumped on the left, stay in walk left state
            // If bumped on the right, transition to walk right state
            else if (bump_right) begin
                next_state = WALK_RIGHT;
            end
            walk_left = 1;
        end
        WALK_RIGHT: begin
            // If ground disappears, transition to falling state
            if (!ground) begin
                next_state = FALLING;
                aaah = 1;
            end
            // If dig is 1, transition to digging state
            else if (dig && ground) begin
                next_state = DIGGING;
                digging = 1;
            end
            // If bumped on the right, stay in walk right state
            // If bumped on the left, transition to walk left state
            else if (bump_left) begin
                next_state = WALK_LEFT;
            end
            walk_right = 1;
        end
        FALLING: begin
            // If ground reappears, transition to walk left or right state
            if (ground) begin
                // Check if Lemming has been falling for more than 20 cycles
                if (fall_counter > 20) begin
                    next_state = 2'b12; // splattered state
                end else begin
                    // Transition to walk left or right state based on current state
                    if (current_state == WALK_LEFT || current_state == DIGGING) begin
                        next_state = WALK_LEFT;
                    end else if (current_state == WALK_RIGHT) begin
                        next_state = WALK_RIGHT;
                    end
                end
            end
            aaah = 1;
        end
        DIGGING: begin
            // If ground disappears, transition to falling state
            if (!ground) begin
                next_state = FALLING;
                aaah = 1;
            end
            digging = 1;
        end
        default: begin // splattered state
            next_state = current_state;
        end
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALK_LEFT;
        fall_counter <= 0;
    end else begin
        current_state <= next_state;
        
        // Update fall counter
        if (current_state == FALLING) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 0;
        end
    end
end

endmodule