module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Define modes with parameters
    localparam MODE_WALK  = 2'b00;
    localparam MODE_DIG   = 2'b01;
    localparam MODE_FALL  = 2'b10;
    localparam MODE_SPLAT = 2'b11;

    // Direction parameters
    localparam DIR_LEFT  = 1'b0;
    localparam DIR_RIGHT = 1'b1;

    // State registers
    reg [1:0] mode;
    reg       direction;
    reg [4:0] fall_timer;

    // Next-state signals
    reg [1:0] next_mode;
    reg       next_direction;
    reg [4:0] next_fall_timer;

    // Sequential block with asynchronous posedge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode      <= MODE_WALK;
            direction <= DIR_LEFT;
            fall_timer <= 5'd0;
        end else begin
            mode      <= next_mode;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Combinational next-state logic
    always @(*) begin
        // Default assignments: hold state, fall_timer reset unless falling
        next_mode = mode;
        next_direction = direction;
        next_fall_timer = 5'd0;

        // Helper signal: bumped on any side
        wire bumped = bump_left || bump_right;

        case (mode)
            MODE_SPLAT: begin
                // Remain in splat forever
                next_mode = MODE_SPLAT;
                next_direction = direction;
                next_fall_timer = 5'd0;
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed, check if splat condition met
                    if (fall_timer > 5'd20) begin
                        next_mode = MODE_SPLAT;
                    end else begin
                        next_mode = MODE_WALK;
                    end
                    next_direction = direction; // direction unchanged
                    next_fall_timer = 5'd0;
                end else begin
                    // Still falling, increment fall timer with saturation
                    next_mode = MODE_FALL;
                    next_direction = direction;
                    if (fall_timer < 5'd21) begin
                        next_fall_timer = fall_timer + 1'b1;
                    end else begin
                        next_fall_timer = 5'd21; // saturate
                    end
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    // Start falling immediately
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else if (dig) begin
                    // Start digging
                    next_mode = MODE_DIG;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                end else begin
                    // Handle bumps to switch direction
                    if (bump_left && bump_right) begin
                        next_direction = ~direction;
                    end else if (bump_left) begin
                        next_direction = DIR_RIGHT;
                    end else if (bump_right) begin
                        next_direction = DIR_LEFT;
                    end else begin
                        next_direction = direction;
                    end
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // No ground beneath while digging -> fall
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else begin
                    // Continue digging
                    next_mode = MODE_DIG;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                end
            end

            default: begin
                // Defensive fallback to known state
                next_mode = MODE_WALK;
                next_direction = DIR_LEFT;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Outputs: Moore machine - depend only on current state
    assign walk_left  = (mode == MODE_WALK) && (direction == DIR_LEFT);
    assign walk_right = (mode == MODE_WALK) && (direction == DIR_RIGHT);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule