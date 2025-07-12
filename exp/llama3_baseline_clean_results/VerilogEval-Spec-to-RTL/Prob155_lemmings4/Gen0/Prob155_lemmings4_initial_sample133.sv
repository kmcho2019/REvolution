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
localparam WALK_LEFT = 0;
localparam WALK_RIGHT = 1;
localparam FALLING = 2;
localparam DIGGING = 3;
localparam SPLATTERED = 4;

// Define the states as wires
reg [2:0] current_state;
reg [2:0] next_state;

// Define the outputs as wires
reg walk_left_wire;
reg walk_right_wire;
reg aaah_wire;
reg digging_wire;

// Define a counter for the fall time
reg [5:0] fall_time;

// Always block to handle the state machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset the state machine to walk left
        current_state <= WALK_LEFT;
        fall_time <= 0;
    end else begin
        // Update the current state and fall time
        current_state <= next_state;
        if (current_state == FALLING) begin
            fall_time <= fall_time + 1;
        end else begin
            fall_time <= 0;
        end
    end
end

// Always block to handle the combinational logic
always @(*) begin
    // Initialize the next state and outputs
    next_state = current_state;
    walk_left_wire = 0;
    walk_right_wire = 0;
    aaah_wire = 0;
    digging_wire = 0;

    // Handle the different states
    case (current_state)
        WALK_LEFT: begin
            // Walk left
            walk_left_wire = 1;
            // If the Lemming is bumped on the right, switch to walk right
            if (bump_right) begin
                next_state = WALK_RIGHT;
            end
            // If the Lemming is bumped on the left, switch to walk right
            else if (bump_left) begin
                next_state = WALK_RIGHT;
            end
            // If the ground disappears, start falling
            else if (!ground) begin
                next_state = FALLING;
            end
            // If the Lemming is told to dig and is currently walking on ground, start digging
            else if (dig && ground) begin
                next_state = DIGGING;
            end
        end
        WALK_RIGHT: begin
            // Walk right
            walk_right_wire = 1;
            // If the Lemming is bumped on the left, switch to walk left
            if (bump_left) begin
                next_state = WALK_LEFT;
            end
            // If the Lemming is bumped on the right, switch to walk left
            else if (bump_right) begin
                next_state = WALK_LEFT;
            end
            // If the ground disappears, start falling
            else if (!ground) begin
                next_state = FALLING;
            end
            // If the Lemming is told to dig and is currently walking on ground, start digging
            else if (dig && ground) begin
                next_state = DIGGING;
            end
        end
        FALLING: begin
            // The Lemming is falling
            aaah_wire = 1;
            // If the ground reappears, stop falling
            if (ground) begin
                // If the Lemming has fallen for more than 20 clock cycles, it will splatter
                if (fall_time > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    // If the Lemming was walking left before falling, resume walking left
                    if (next_state == WALK_LEFT) begin
                        next_state = WALK_LEFT;
                    end
                    // If the Lemming was walking right before falling, resume walking right
                    else if (next_state == WALK_RIGHT) begin
                        next_state = WALK_RIGHT;
                    end
                end
            end
        end
        DIGGING: begin
            // The Lemming is digging
            digging_wire = 1;
            // If the ground disappears, stop digging and start falling
            if (!ground) begin
                next_state = FALLING;
            end
        end
        SPLATTERED: begin
            // The Lemming has splattered and is no longer active
        end
        default: begin
            // Default state
        end
    endcase
end

// Assign the outputs
assign walk_left = walk_left_wire;
assign walk_right = walk_right_wire;
assign aaah = aaah_wire;
assign digging = digging_wire;

endmodule