module TopModule(
    input clk,
    input areset,       // asynchronous posedge reset
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // One-hot state encoding
    reg walk_state, dig_state, fall_state, splat_state;
    reg direction; // 0=left, 1=right
    reg [4:0] fall_timer;

    // Asynchronous reset and state registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_state  <= 1'b1;
            dig_state   <= 1'b0;
            fall_state  <= 1'b0;
            splat_state <= 1'b0;
            direction   <= 1'b0; // walk left initially
            fall_timer  <= 5'd0;
        end else begin
            walk_state  <= walk_state_next;
            dig_state   <= dig_state_next;
            fall_state  <= fall_state_next;
            splat_state <= splat_state_next;
            direction   <= direction_next;
            fall_timer  <= fall_timer_next;
        end
    end

    // Next state logic signals
    reg walk_state_next, dig_state_next, fall_state_next, splat_state_next;
    reg direction_next;
    reg [4:0] fall_timer_next;

    always @(*) begin
        // Default next states hold current
        walk_state_next  = walk_state;
        dig_state_next   = dig_state;
        fall_state_next  = fall_state;
        splat_state_next = splat_state;
        direction_next   = direction;
        fall_timer_next  = fall_timer;

        // Priority: splat > fall > dig > walk

        if (splat_state) begin
            // Remain splatted forever
            walk_state_next = 1'b0;
            dig_state_next = 1'b0;
            fall_state_next = 1'b0;
            splat_state_next = 1'b1;
            fall_timer_next = 5'd0;
            // direction no longer matters
        end else if (fall_state) begin
            if (ground) begin
                // Landed from fall
                if (fall_timer > 5'd20) begin
                    // splat
                    walk_state_next = 1'b0;
                    dig_state_next = 1'b0;
                    fall_state_next = 1'b0;
                    splat_state_next = 1'b1;
                    fall_timer_next = 5'd0;
                end else begin
                    // resume walking same direction
                    walk_state_next = 1'b1;
                    dig_state_next = 1'b0;
                    fall_state_next = 1'b0;
                    splat_state_next = 1'b0;
                    fall_timer_next = 5'd0;
                end
            end else begin
                // still falling, increment fall timer saturating at 31
                walk_state_next = 1'b0;
                dig_state_next = 1'b0;
                fall_state_next = 1'b1;
                splat_state_next = 1'b0;
                fall_timer_next = (fall_timer < 5'd31) ? fall_timer + 1 : 5'd31;
            end
        end else if (dig_state) begin
            // Currently digging
            if (!ground) begin
                // ground gone: start falling
                walk_state_next = 1'b0;
                dig_state_next = 1'b0;
                fall_state_next = 1'b1;
                splat_state_next = 1'b0;
                fall_timer_next = 5'd1;
            end else begin
                // keep digging, no direction or fall_timer change
                walk_state_next = 1'b0;
                dig_state_next = 1'b1;
                fall_state_next = 1'b0;
                splat_state_next = 1'b0;
                fall_timer_next = 5'd0;
            end
        end else begin
            // walking state
            if (!ground) begin
                // start falling
                walk_state_next = 1'b0;
                dig_state_next = 1'b0;
                fall_state_next = 1'b1;
                splat_state_next = 1'b0;
                fall_timer_next = 5'd1;
            end else if (dig) begin
                // start digging
                walk_state_next = 1'b0;
                dig_state_next = 1'b1;
                fall_state_next = 1'b0;
                splat_state_next = 1'b0;
                fall_timer_next = 5'd0;
            end else begin
                // remain walking
                walk_state_next = 1'b1;
                dig_state_next = 1'b0;
                fall_state_next = 1'b0;
                splat_state_next = 1'b0;
                fall_timer_next = 5'd0;

                // direction change logic on bump
                if (bump_left && bump_right) begin
                    direction_next = ~direction;
                end else if (bump_left) begin
                    direction_next = 1'b1; // walk right
                end else if (bump_right) begin
                    direction_next = 1'b0; // walk left
                end else begin
                    direction_next = direction; // no change
                end
            end
        end
    end

    // Moore outputs
    assign walk_left  = walk_state && (direction == 1'b0);
    assign walk_right = walk_state && (direction == 1'b1);
    assign aaah       = fall_state;
    assign digging    = dig_state;

endmodule