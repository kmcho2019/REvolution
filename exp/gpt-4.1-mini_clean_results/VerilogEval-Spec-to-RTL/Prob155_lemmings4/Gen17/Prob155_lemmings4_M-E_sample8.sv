module TopModule (
    input  clk,
    input  areset,        // asynchronous posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding (3 bits):
    // bit2   bit1 bit0
    //  0      0    0   WALK_LEFT
    //  0      0    1   WALK_RIGHT
    //  0      1    0   DIG_LEFT
    //  0      1    1   DIG_RIGHT
    //  1      0    0   FALL_LEFT
    //  1      0    1   FALL_RIGHT
    //  1      1    0   SPLAT (no direction)
    //  1      1    1   unused (treated as SPLAT for safety)
    localparam
        WALK_LEFT  = 3'b000,
        WALK_RIGHT = 3'b001,
        DIG_LEFT   = 3'b010,
        DIG_RIGHT  = 3'b011,
        FALL_LEFT  = 3'b100,
        FALL_RIGHT = 3'b101,
        SPLAT      = 3'b110;

    reg [2:0] state, next_state;
    reg [4:0] fall_timer, next_fall_timer;

    // Async reset, posedge
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    // Helper: extract current direction bit (LSB), 0=left,1=right
    wire direction = state[0];
    wire is_walking = (state == WALK_LEFT) || (state == WALK_RIGHT);
    wire is_digging = (state == DIG_LEFT) || (state == DIG_RIGHT);
    wire is_falling = (state == FALL_LEFT) || (state == FALL_RIGHT);
    wire is_splat   = (state == SPLAT);

    // Next state logic prioritizing: fall > dig > bump > else hold or splat forever
    always @(*) begin
        next_state = state;
        next_fall_timer = fall_timer;

        if (is_splat) begin
            // Stay splatted forever, no outputs
            next_state = SPLAT;
            next_fall_timer = 5'd0;
        end else if (is_falling) begin
            if (ground) begin
                // Landed: splat if fallen too long, else walk in falling direction
                if (fall_timer > 5'd20)
                    next_state = SPLAT;
                else
                    next_state = direction ? WALK_RIGHT : WALK_LEFT;
                next_fall_timer = 5'd0;
            end else begin
                // Continue falling, increment timer but saturate at max 31 to avoid overflow
                next_state = state;
                next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 5'd1;
            end
        end else if (!ground) begin
            // Ground lost => fall, starting timer at 1
            // Direction from current walking or digging state
            if (is_walking)
                next_state = direction ? FALL_RIGHT : FALL_LEFT;
            else if (is_digging)
                next_state = direction ? FALL_RIGHT : FALL_LEFT;
            else
                next_state = FALL_LEFT; // Default safe fallback
            next_fall_timer = 5'd1;
        end else if (is_walking) begin
            // On ground walking
            if (dig) begin
                // Start digging same direction
                next_state = direction ? DIG_RIGHT : DIG_LEFT;
                next_fall_timer = 5'd0;
            end else if (bump_left && bump_right) begin
                // Both bumps: reverse direction
                next_state = direction ? WALK_LEFT : WALK_RIGHT;
                next_fall_timer = 5'd0;
            end else if (bump_left) begin
                // bumped left => walk right
                next_state = WALK_RIGHT;
                next_fall_timer = 5'd0;
            end else if (bump_right) begin
                // bumped right => walk left
                next_state = WALK_LEFT;
                next_fall_timer = 5'd0;
            end else begin
                // Continue walking same direction
                next_state = state;
                next_fall_timer = 5'd0;
            end
        end else if (is_digging) begin
            // Digging on ground: continue until no ground
            if (!ground) begin
                // start falling in dig direction, timer=1
                next_state = direction ? FALL_RIGHT : FALL_LEFT;
                next_fall_timer = 5'd1;
            end else begin
                // Continue digging
                next_state = state;
                next_fall_timer = 5'd0;
            end
        end else begin
            // For safety, if in unknown state, reset to walking left
            next_state = WALK_LEFT;
            next_fall_timer = 5'd0;
        end
    end

    // Outputs as Moore outputs from state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = is_falling;
    assign digging    = is_digging;

endmodule