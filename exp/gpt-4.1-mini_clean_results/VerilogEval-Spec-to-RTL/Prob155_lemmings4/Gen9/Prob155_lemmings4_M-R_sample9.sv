module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // Define states as localparam with typedef for clarity
    typedef enum logic [1:0] {
        MODE_WALK = 2'b00,
        MODE_DIG  = 2'b01,
        MODE_FALL = 2'b10,
        MODE_SPLAT= 2'b11
    } mode_t;

    mode_t mode, next_mode;

    reg direction, next_direction; // 0 = left, 1 = right

    // Fall timer counter (max 31)
    reg [4:0] fall_timer, next_fall_timer;

    // Counter enable for fall_timer increment
    wire fall_timer_en = (mode == MODE_FALL) && (!ground) && (fall_timer < 5'd31);

    // Handle asynchronous reset separately for mode, direction, and fall_timer
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode       <= MODE_WALK;
            direction  <= 1'b0;   // walk left initially
            fall_timer <= 5'd0;
        end else begin
            mode       <= next_mode;
            direction  <= next_direction;
            if (fall_timer_en)
                fall_timer <= fall_timer + 5'd1;
            else if (mode == MODE_FALL && ground)
                fall_timer <= 5'd0;
            else if (mode != MODE_FALL)
                fall_timer <= 5'd0;
        end
    end

    // Combinational block: determine next state, direction, and outputs
    always @* begin
        // Default assignments to current values
        next_mode = mode;
        next_direction = direction;

        // Outputs default to 0; will update below
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;
        digging    = 1'b0;

        case (mode)
            MODE_SPLAT: begin
                // Once splatted, no outputs asserted
                next_mode = MODE_SPLAT;
                // all outputs remain zero
            end

            MODE_FALL: begin
                aaah = 1'b1;
                if (ground) begin
                    // Landed: splat if fallen > 20 cycles, else walk in prior direction
                    if (fall_timer > 5'd20) begin
                        next_mode = MODE_SPLAT;
                    end else begin
                        next_mode = MODE_WALK;
                    end
                    // direction unchanged
                end else begin
                    next_mode = MODE_FALL; // keep falling
                end
            end

            MODE_WALK: begin
                // Determine if bump on left/right and resulting direction
                // Use priority: fall > dig > bump

                if (!ground) begin
                    // Start falling: mode FALL, fall_timer increments handled by counter enable
                    next_mode = MODE_FALL;
                end else if (dig) begin
                    next_mode = MODE_DIG;
                end else if (bump_left | bump_right) begin
                    // Bump direction logic:
                    // if both bump, flip direction
                    // else bump_left only -> walk right
                    // else bump_right only -> walk left

                    if (bump_left & bump_right)
                        next_direction = ~direction;
                    else if (bump_left)
                        next_direction = 1'b1; // walk right
                    else // bump_right only
                        next_direction = 1'b0; // walk left

                    next_mode = MODE_WALK;
                end else begin
                    next_mode = MODE_WALK;
                end

                // Set walking outputs based on next_direction
                walk_left  = (next_mode == MODE_WALK) && (next_direction == 1'b0);
                walk_right = (next_mode == MODE_WALK) && (next_direction == 1'b1);
            end

            MODE_DIG: begin
                digging = 1'b1;
                if (!ground) begin
                    // Lost ground while digging, start falling
                    next_mode = MODE_FALL;
                end else begin
                    next_mode = MODE_DIG;
                end

                // walking outputs off during digging
            end

            default: begin
                // Recover to walk left if unknown state
                next_mode = MODE_WALK;
                next_direction = 1'b0;
                walk_left = 1'b1;
            end
        endcase
    end

endmodule