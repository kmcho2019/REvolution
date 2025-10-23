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

    typedef enum logic [2:0] {
        WALK  = 3'b001,
        DIG   = 3'b010,
        FALL  = 3'b100,
        SPLAT = 3'b000 // SPLAT as zero state for simple checking
    } mode_t;

    mode_t mode, mode_next;
    logic direction, direction_next; // 0-left, 1-right

    logic [5:0] fall_timer, fall_timer_next; // 6-bit to saturate beyond 20 safely

    // Synchronize asynchronous reset with clk, producing a synchronous reset signal
    logic areset_sync1, areset_sync2;
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            areset_sync1 <= 1;
            areset_sync2 <= 1;
        end else begin
            areset_sync1 <= 0;
            areset_sync2 <= areset_sync1;
        end
    end
    wire sync_reset = areset_sync2;

    // Sequential logic: update mode, direction and fall_timer
    always_ff @(posedge clk) begin
        if (sync_reset) begin
            mode <= WALK;
            direction <= 1'b0; // start walking left
            fall_timer <= 6'd0;
        end else begin
            mode <= mode_next;
            direction <= direction_next;
            fall_timer <= fall_timer_next;
        end
    end

    // Combinational next-state logic with explicit priority
    always_comb begin
        mode_next = mode;
        direction_next = direction;
        fall_timer_next = fall_timer;

        case (mode)
            SPLAT: begin
                // Stays splatted forever until reset
                mode_next = SPLAT;
                fall_timer_next = 6'd0;
                direction_next = direction; // irrelevant
            end

            FALL: begin
                if (ground) begin
                    // Lemming hits ground after fall
                    if (fall_timer > 6'd20)
                        mode_next = SPLAT; // splat
                    else
                        mode_next = WALK;  // resume walking
                    fall_timer_next = 6'd0;
                    direction_next = direction;
                end else begin
                    // Continue falling and saturate fall_timer at max 63
                    if (fall_timer < 6'd63)
                        fall_timer_next = fall_timer + 1;
                    mode_next = FALL;
                    direction_next = direction; // bumps ignored while falling
                end
            end

            WALK: begin
                // Prioritize falling
                if (!ground) begin
                    mode_next = FALL;
                    fall_timer_next = 6'd1;
                    direction_next = direction;
                end else if (dig) begin
                    // Digging if ground and walking
                    mode_next = DIG;
                    fall_timer_next = 6'd0;
                    direction_next = direction;
                end else begin
                    // Handle bumps to flip direction
                    if ((bump_left && bump_right) || bump_left)
                        direction_next = 1'b1; // walk right on bump left or both
                    else if (bump_right)
                        direction_next = 1'b0; // walk left on bump right
                    else
                        direction_next = direction;

                    mode_next = WALK;
                    fall_timer_next = 6'd0;
                end
            end

            DIG: begin
                if (!ground) begin
                    // Digging ended by falling ground
                    mode_next = FALL;
                    fall_timer_next = 6'd1;
                    direction_next = direction; // bump ignored
                end else begin
                    mode_next = DIG;
                    fall_timer_next = 6'd0;
                    direction_next = direction; // bumps ignored during digging
                end
            end

            default: begin
                // Safety fallback: treat as splat
                mode_next = SPLAT;
                fall_timer_next = 6'd0;
                direction_next = direction;
            end
        endcase
    end

    // Moore outputs depend only on mode and direction
    assign walk_left  = (mode == WALK) && (direction == 1'b0);
    assign walk_right = (mode == WALK) && (direction == 1'b1);
    assign aaah       = (mode == FALL);
    assign digging    = (mode == DIG);

endmodule