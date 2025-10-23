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

    // States
    localparam WALK  = 2'd0;
    localparam DIG   = 2'd1;
    localparam FALL  = 2'd2;
    localparam SPLAT = 2'd3;

    reg [1:0] state, next_state;
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // start walking left
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    always @(*) begin
        next_state = state;
        next_direction = direction;
        next_fall_timer = 5'd0;

        case (state)
            SPLAT: begin
                // Remain splatted forever
                next_state = SPLAT;
                next_direction = direction;
                next_fall_timer = 5'd0;
            end

            FALL: begin
                if (ground) begin
                    if (fall_timer > 5'd20)
                        next_state = SPLAT;
                    else
                        next_state = WALK;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                end else begin
                    next_state = FALL;
                    next_direction = direction;
                    // saturate at 31
                    next_fall_timer = (fall_timer < 5'd31) ? fall_timer + 1 : 5'd31;
                end
            end

            WALK: begin
                if (!ground) begin
                    // Start falling
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else if (dig) begin
                    // Start digging if on ground
                    next_state = DIG;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                end else if (bump_left || bump_right) begin
                    // Switch directions on bump
                    // Both bumps toggle direction
                    if (bump_left && bump_right)
                        next_direction = ~direction;
                    else if (bump_left)
                        next_direction = 1'b1; // walk right
                    else
                        next_direction = 1'b0; // walk left
                    next_state = WALK;
                    next_fall_timer = 5'd0;
                end else begin
                    // Keep walking
                    next_state = WALK;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                end
            end

            DIG: begin
                if (!ground) begin
                    // Fall if ground disappears while digging
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else begin
                    // Continue digging
                    next_state = DIG;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                end
            end

            default: begin
                next_state = WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule