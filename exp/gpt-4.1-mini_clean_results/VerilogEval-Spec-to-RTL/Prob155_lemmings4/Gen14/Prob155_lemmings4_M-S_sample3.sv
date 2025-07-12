module TopModule(
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

    // State encoding
    parameter WALK = 2'd0,
              DIG  = 2'd1,
              FALL = 2'd2,
              SPLAT= 2'd3;

    reg [1:0] state, next_state;
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer; // 5 bits to count up to >20

    wire bump_both = bump_left & bump_right;

    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK;
            direction  <= 1'b0; // walk left after reset
            fall_timer <= 5'd0;
        end else begin
            state      <= next_state;
            direction  <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state and outputs logic
    always @* begin
        // Default next values
        next_state      = state;
        next_direction  = direction;
        next_fall_timer = fall_timer;

        case(state)
            SPLAT: begin
                // Stay splatted forever
                next_state      = SPLAT;
                next_fall_timer = 5'd0;
            end

            FALL: begin
                if (ground) begin
                    // Landed
                    if (fall_timer > 5'd20)
                        next_state = SPLAT;
                    else
                        next_state = WALK;
                    next_fall_timer = 5'd0;
                    // direction unchanged
                end else begin
                    // Still falling, increment timer saturate at 31
                    next_state = FALL;
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1;
                end
                // direction unchanged
            end

            DIG: begin
                if (!ground) begin
                    // Start falling if no ground
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                end else begin
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    // direction unchanged
                end
            end

            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    // direction unchanged
                end else if (dig) begin
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    // direction unchanged
                end else begin
                    // Handle bump direction changes
                    if (bump_both)
                        next_direction = ~direction;
                    else if (bump_left)
                        next_direction = 1'b1;
                    else if (bump_right)
                        next_direction = 1'b0;
                    else
                        next_direction = direction;
                    next_state = WALK;
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

    // Moore outputs depend on state and direction
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule