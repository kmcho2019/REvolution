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

// State encoding (2 bits)
localparam WALKING = 2'b00;
localparam FALLING = 2'b01;
localparam DIGGING = 2'b10;

// Registers for current state and direction
// dir: 0 = left, 1 = right
reg [1:0] state, next_state;
reg dir, next_dir;

// Register to hold previous ground to detect stable ground condition
reg prev_ground;

// Sequential logic: async reset, update state, direction and prev_ground
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        dir <= 1'b0;          // walk left on reset
        prev_ground <= 1'b1;  // assume on ground at reset
    end else begin
        state <= next_state;
        dir <= next_dir;
        prev_ground <= ground;
    end
end

// Stable ground: ground held high for at least two cycles
wire stable_ground = (ground == 1'b1) && (prev_ground == 1'b1);

always @(*) begin
    // Default hold current state and direction
    next_state = state;
    next_dir = dir;

    case (state)
        WALKING: begin
            // Priority: fall > dig > bump

            if (ground == 1'b0) begin
                // Start falling immediately if no ground
                next_state = FALLING;
                // Direction unchanged during fall
                next_dir = dir;
            end
            else if (dig && stable_ground) begin
                // Start digging if commanded and stable ground
                next_state = DIGGING;
                // Direction unchanged during digging
                next_dir = dir;
            end
            else if (stable_ground && (bump_left || bump_right)) begin
                // Bump logic:
                // Both bumps: toggle direction
                if (bump_left && bump_right) begin
                    next_dir = ~dir;
                end
                // Only bump_left: walk right (dir=1)
                else if (bump_left) begin
                    next_dir = 1'b1;
                end
                // Only bump_right: walk left (dir=0)
                else /* bump_right only */ begin
                    next_dir = 1'b0;
                end
                // Remain walking after bump
                next_state = WALKING;
            end
            else begin
                // No condition met, hold walking state and direction
                next_state = WALKING;
                next_dir = dir;
            end
        end

        FALLING: begin
            // Stay falling until ground returns, then resume walking same direction
            if (ground == 1'b1) begin
                next_state = WALKING;
                next_dir = dir;
            end else begin
                next_state = FALLING;
                next_dir = dir;
            end
        end

        DIGGING: begin
            // Stay digging on ground; if ground lost, fall
            if (ground == 1'b0) begin
                next_state = FALLING;
                next_dir = dir;
            end else begin
                next_state = DIGGING;
                next_dir = dir;
            end
        end

        default: begin
            // Safety fallback: walk left
            next_state = WALKING;
            next_dir = 1'b0;
        end
    endcase
end

// Moore outputs depend on current state and direction
assign walk_left  = (state == WALKING) && (dir == 1'b0);
assign walk_right = (state == WALKING) && (dir == 1'b1);
assign aaah       = (state == FALLING);
assign digging    = (state == DIGGING);

endmodule