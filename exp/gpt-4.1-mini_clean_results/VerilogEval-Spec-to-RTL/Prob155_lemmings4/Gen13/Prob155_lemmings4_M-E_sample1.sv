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

    // One-hot mode bits
    // walk = 4'b0001, dig = 4'b0010, fall = 4'b0100, splat = 4'b1000
    reg [3:0] mode;
    reg [3:0] mode_next;

    // Direction: 0=left,1=right
    reg direction, direction_next;

    // 5-bit fall timer, counts only during fall
    reg [4:0] fall_timer, fall_timer_next;

    wire bumped = bump_left | bump_right;
    wire both_bumped = bump_left & bump_right;

    // Mode encoding parameters for clarity
    localparam WALK = 4'b0001,
               DIG  = 4'b0010,
               FALL = 4'b0100,
               SPLAT= 4'b1000;

    // Asynchronous reset and state registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= WALK;
            direction <= 1'b0; // start walking left
            fall_timer <= 5'd0;
        end else begin
            mode <= mode_next;
            direction <= direction_next;
            fall_timer <= fall_timer_next;
        end
    end

    // Next-state logic combinational
    always @(*) begin
        // Defaults: hold current state and timer
        mode_next = mode;
        direction_next = direction;
        fall_timer_next = fall_timer;

        casez(mode)
            WALK: begin
                if (!ground) begin
                    // start falling
                    mode_next = FALL;
                    fall_timer_next = 5'd1;
                end else if (dig) begin
                    mode_next = DIG;
                end else begin
                    // change direction if bumped
                    if (both_bumped)
                        direction_next = ~direction;
                    else if (bump_left)
                        direction_next = 1'b1; // walk right
                    else if (bump_right)
                        direction_next = 1'b0; // walk left
                end
            end

            DIG: begin
                if (!ground) begin
                    // ground gone during dig: fall now
                    mode_next = FALL;
                    fall_timer_next = 5'd1;
                end
            end

            FALL: begin
                if (ground) begin
                    // landed
                    if (fall_timer > 5'd20) begin
                        mode_next = SPLAT; // splat after long fall
                        fall_timer_next = 5'd0;
                    end else begin
                        mode_next = WALK;  // resume walking
                        fall_timer_next = 5'd0;
                    end
                end else begin
                    // increment fall timer saturating at 31
                    fall_timer_next = (fall_timer < 5'd31) ? fall_timer + 1 : fall_timer;
                end
            end

            SPLAT: begin
                // remain splatted forever
                mode_next = SPLAT;
                // direction and timer frozen
            end

            default: begin
                // Safety fallback to walking left on unknown state
                mode_next = WALK;
                direction_next = 1'b0;
                fall_timer_next = 5'd0;
            end
        endcase
    end

    // Moore outputs depend solely on current mode and direction
    assign walk_left  = (mode == WALK) && (direction == 1'b0);
    assign walk_right = (mode == WALK) && (direction == 1'b1);
    assign aaah       = (mode == FALL);
    assign digging    = (mode == DIG);

endmodule