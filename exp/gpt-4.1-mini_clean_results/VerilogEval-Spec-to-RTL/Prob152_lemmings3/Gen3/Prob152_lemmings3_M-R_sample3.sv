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

// Define behavior states (2 bits)
localparam WALKING = 2'b00;
localparam FALLING = 2'b01;
localparam DIGGING = 2'b10;

// Direction bit: 0=left, 1=right

reg [1:0] state, next_state;
reg dir, next_dir;

reg prev_ground;

// Update previous ground and state on clock with async reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        dir <= 1'b0;         // Start walking left
        prev_ground <= 1'b1; // Assume ground present at reset
    end else begin
        state <= next_state;
        dir <= next_dir;
        prev_ground <= ground;
    end
end

// Helper: stable ground means ground=1 and prev_ground=1 (no edge)
wire stable_ground = (ground == 1'b1) && (prev_ground == 1'b1);

// Determine next direction only when walking and stable_ground
// Logic:
// - If both bump_left and bump_right are 1: flip direction
// - Else if bump_left=1: direction = 1 (right)
// - Else if bump_right=1: direction = 0 (left)
// - Else keep direction

always @(*) begin
    // Default next_dir and next_state hold current values
    next_dir = dir;
    next_state = state;

    case (state)
        WALKING: begin
            if (ground == 1'b0) begin
                // Ground lost: start falling, direction unchanged
                next_state = FALLING;
            end else if (dig == 1'b1 && stable_ground) begin
                // Start digging only if on stable ground
                next_state = DIGGING;
            end else if (stable_ground && (bump_left || bump_right)) begin
                // Update direction according to bumps
                if (bump_left && bump_right) begin
                    // Both bumps: flip direction
                    next_dir = ~dir;
                end else if (bump_left) begin
                    // Bumped on left: walk right
                    next_dir = 1'b1;
                end else if (bump_right) begin
                    // Bumped on right: walk left
                    next_dir = 1'b0;
                end
                // Continue walking state
                next_state = WALKING;
            end else begin
                // No changes
                next_state = WALKING;
                next_dir = dir;
            end
        end

        FALLING: begin
            if (ground == 1'b1) begin
                // Ground regained: resume walking same direction
                next_state = WALKING;
            end else begin
                // Keep falling, direction unchanged
                next_state = FALLING;
            end
            next_dir = dir;
        end

        DIGGING: begin
            if (ground == 1'b0) begin
                // Ground gone while digging: start falling
                next_state = FALLING;
            end else begin
                // Keep digging
                next_state = DIGGING;
            end
            next_dir = dir;
        end

        default: begin
            // Safety fallback
            next_state = WALKING;
            next_dir = 1'b0;
        end
    endcase
end

// Outputs reflect current state and direction (Moore machine)
assign walk_left  = (state == WALKING) && (dir == 1'b0);
assign walk_right = (state == WALKING) && (dir == 1'b1);
assign aaah       = (state == FALLING);
assign digging    = (state == DIGGING);

endmodule