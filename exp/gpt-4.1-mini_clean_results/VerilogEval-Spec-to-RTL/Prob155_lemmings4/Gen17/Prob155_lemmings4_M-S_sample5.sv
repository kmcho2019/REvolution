module TopModule (
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

    // Mode states
    localparam WALK = 2'b00;
    localparam DIG  = 2'b01;
    localparam FALL = 2'b10;
    localparam SPLAT= 2'b11;

    reg [1:0] mode, next_mode;
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer; // count fall duration

    wire bump = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= WALK;
            direction <= 1'b0; // walk left
            fall_timer <= 0;
        end else begin
            mode <= next_mode;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    always @(*) begin
        // Default to current state
        next_mode = mode;
        next_direction = direction;
        next_fall_timer = fall_timer;

        case (mode)
            SPLAT: begin
                // Remain splatted forever
                next_mode = SPLAT;
                next_fall_timer = 0;
                // direction unchanged
            end

            FALL: begin
                if (ground) begin
                    // Landed: splat if fallen > 20 cycles
                    if (fall_timer > 20) next_mode = SPLAT;
                    else next_mode = WALK;
                    next_fall_timer = 0;
                end else begin
                    // Continue falling; saturate at 31
                    next_fall_timer = (fall_timer == 5'd31) ? 31 : fall_timer + 1;
                end
                // direction unchanged while falling
                next_direction = direction;
            end

            DIG: begin
                if (!ground) begin
                    // Fall after digging into hole
                    next_mode = FALL;
                    next_fall_timer = 1;
                end else begin
                    // Continue digging
                    next_mode = DIG;
                    next_fall_timer = 0;
                end
                next_direction = direction;
            end

            WALK: begin
                if (!ground) begin
                    // Fall start
                    next_mode = FALL;
                    next_fall_timer = 1;
                    next_direction = direction;
                end else if (dig) begin
                    // Start digging if on ground
                    next_mode = DIG;
                    next_fall_timer = 0;
                    next_direction = direction;
                end else begin
                    // Walking on ground; change direction if bumped
                    next_mode = WALK;
                    next_fall_timer = 0;
                    if (bump_both)
                        next_direction = ~direction;
                    else if (bump_left)
                        next_direction = 1'b1; // walk right
                    else if (bump_right)
                        next_direction = 1'b0; // walk left
                    else
                        next_direction = direction;
                end
            end

            default: begin
                next_mode = WALK;
                next_direction = 1'b0;
                next_fall_timer = 0;
            end
        endcase
    end

    // Outputs
    assign walk_left  = (mode == WALK) && (direction == 1'b0);
    assign walk_right = (mode == WALK) && (direction == 1'b1);
    assign aaah       = (mode == FALL);
    assign digging    = (mode == DIG);

endmodule