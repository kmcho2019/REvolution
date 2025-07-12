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

    // State encoding as localparams (one-hot style)
    localparam WALK  = 2'b00;
    localparam DIG   = 2'b01;
    localparam FALL  = 2'b10;
    localparam SPLAT = 2'b11;

    reg [1:0] state, next_state;

    // Direction: 0=left, 1=right stored in reg
    reg direction, next_direction;

    // 5-bit fall timer with saturation
    reg [4:0] fall_timer, next_fall_timer;

    // ----------- Direction update logic -----------
    // Update direction only when walking and bumped, otherwise hold
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk left on reset
        end else begin
            direction <= next_direction;
        end
    end

    // ----------- Fall timer update logic -----------
    // Increment during falling saturating at 31, reset otherwise
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            fall_timer <= 5'd0;
        end else begin
            fall_timer <= next_fall_timer;
        end
    end

    // ----------- State update logic -----------
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
        end else begin
            state <= next_state;
        end
    end

    // ----------- Next state and outputs logic -----------
    always @(*) begin
        // Defaults: hold current values
        next_state = state;
        next_fall_timer = 5'd0; // default zero when not falling
        next_direction = direction;

        // splat condition for landing after long fall
        wire splat_condition = (fall_timer > 5'd20);

        if (state == SPLAT) begin
            // stay splatted forever
            next_state = SPLAT;
            next_fall_timer = 5'd0;
            // direction no change
        end else if (state == FALL) begin
            if (ground) begin
                if (splat_condition) begin
                    next_state = SPLAT;
                end else begin
                    next_state = WALK;
                end
                next_fall_timer = 5'd0;
                // direction preserved on landing
            end else begin
                next_state = FALL;
                // Saturate fall_timer increment at 31
                if (fall_timer == 5'd31) begin
                    next_fall_timer = 5'd31;
                end else begin
                    next_fall_timer = fall_timer + 1'b1;
                end
            end
        end else if (state == DIG) begin
            if (!ground) begin
                // lost ground while digging -> fall
                next_state = FALL;
                next_fall_timer = 5'd1;
            end else begin
                // continue digging
                next_state = DIG;
                next_fall_timer = 5'd0;
            end
        end else if (state == WALK) begin
            if (!ground) begin
                // start falling
                next_state = FALL;
                next_fall_timer = 5'd1;
            end else if (dig) begin
                // start digging only on ground
                next_state = DIG;
                next_fall_timer = 5'd0;
            end else begin
                // Handle bumps - change direction
                next_state = WALK;
                next_fall_timer = 5'd0;
                // direction updated only on bumps
                if (bump_left && bump_right) begin
                    // both bump -> toggle direction
                    next_direction = ~direction;
                end else if (bump_left) begin
                    // bump left -> walk right
                    next_direction = 1'b1;
                end else if (bump_right) begin
                    // bump right -> walk left
                    next_direction = 1'b0;
                end else begin
                    next_direction = direction;
                end
            end
        end else begin
            // Default reset state fallback
            next_state = WALK;
            next_fall_timer = 5'd0;
            next_direction = 1'b0;
        end
    end

    // ----------- Outputs (Moore) -----------
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule