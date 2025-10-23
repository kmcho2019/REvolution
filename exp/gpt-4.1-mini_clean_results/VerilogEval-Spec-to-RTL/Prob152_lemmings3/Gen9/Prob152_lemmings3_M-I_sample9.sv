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

// One-hot state encoding (3 bits)
localparam WALKING = 3'b001;
localparam FALLING = 3'b010;
localparam DIGGING = 3'b100;

// Registers for current state and direction
// dir: 0 = left, 1 = right
reg [2:0] state, next_state;
reg dir, next_dir;

// Register to hold previous ground to detect stable ground condition
// Update prev_ground only when ground=1 to reduce toggle activity
reg prev_ground;

// Sequential logic: synchronous reset, update state, direction and prev_ground
always @(posedge clk) begin
    if (areset) begin
        state <= WALKING;
        dir <= 1'b0;          // walk left on reset
        prev_ground <= 1'b1;  // assume on ground at reset
    end else begin
        state <= next_state;
        dir <= next_dir;
        // Update prev_ground only if ground is 1, else hold previous value
        if (ground)
            prev_ground <= 1'b1;
        else
            prev_ground <= 1'b0;
    end
end

// Stable ground: ground held high for at least two cycles
wire stable_ground = ground && prev_ground;

always @(*) begin
    // Default hold current state and direction
    next_state = state;
    next_dir = dir;

    if (state == WALKING) begin
        // Priority: fall > dig > bump

        if (!ground) begin
            // Start falling immediately if no ground
            next_state = FALLING;
            next_dir = dir;
        end else if (dig && stable_ground) begin
            // Start digging if commanded and stable ground
            next_state = DIGGING;
            next_dir = dir;
        end else if (stable_ground && (bump_left || bump_right)) begin
            // Bump logic:
            if (bump_left && bump_right) begin
                next_dir = ~dir;
            end else if (bump_left) begin
                next_dir = 1'b1; // walk right
            end else begin
                next_dir = 1'b0; // walk left
            end
            next_state = WALKING;
        end else begin
            next_state = WALKING;
            next_dir = dir;
        end
    end else if (state == FALLING) begin
        // Stay falling until ground returns, then resume walking same direction
        if (ground) begin
            next_state = WALKING;
            next_dir = dir;
        end else begin
            next_state = FALLING;
            next_dir = dir;
        end
    end else if (state == DIGGING) begin
        // Stay digging on ground; if ground lost, fall
        if (!ground) begin
            next_state = FALLING;
            next_dir = dir;
        end else begin
            next_state = DIGGING;
            next_dir = dir;
        end
    end else begin
        // Safety fallback: walk left
        next_state = WALKING;
        next_dir = 1'b0;
    end
end

// Moore outputs depend on current state and direction
assign walk_left  = (state == WALKING) && (dir == 1'b0);
assign walk_right = (state == WALKING) && (dir == 1'b1);
assign aaah       = (state == FALLING);
assign digging    = (state == DIGGING);

endmodule