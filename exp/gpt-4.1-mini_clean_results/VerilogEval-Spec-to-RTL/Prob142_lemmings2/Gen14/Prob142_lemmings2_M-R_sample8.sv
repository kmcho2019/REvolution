module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // Define FSM states using enumerated typedef for readability
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'd0,
        WALK_RIGHT = 2'd1,
        FALL_LEFT  = 2'd2,
        FALL_RIGHT = 2'd3
    } state_t;

    state_t state, next_state;

    // Extract direction and falling flags for convenience
    wire falling;
    wire direction; // 0 = left, 1 = right

    assign falling   = (state == FALL_LEFT) || (state == FALL_RIGHT);
    assign direction = (state == WALK_RIGHT) || (state == FALL_RIGHT);

    // Combinational next state logic
    always @(*) begin
        next_state = state; // Default hold

        if (falling) begin
            // Currently falling: ignore bumps
            if (ground) begin
                // Ground reappeared: resume walking same direction
                next_state = direction ? WALK_RIGHT : WALK_LEFT;
            end
            // else remain falling
        end else begin
            // Walking on ground
            if (!ground) begin
                // Start falling, keep direction
                next_state = direction ? FALL_RIGHT : FALL_LEFT;
            end else begin
                // Bumps cause direction change
                if (bump_left && bump_right) begin
                    // Both bumps: flip direction
                    next_state = direction ? WALK_LEFT : WALK_RIGHT;
                end else if (bump_left) begin
                    // Bump left: walk right
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    // Bump right: walk left
                    next_state = WALK_LEFT;
                end
                // else no bump: hold state
            end
        end
    end

    // Sequential state register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Moore outputs derived from state
    assign aaah       = falling;
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule