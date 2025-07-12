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

    // State encoding
    localparam WALK  = 2'd0;
    localparam DIG   = 2'd1;
    localparam FALL  = 2'd2;
    localparam SPLAT = 2'd3;

    reg [1:0] state, next_state;
    reg       direction, next_direction; // 0=left,1=right
    reg [4:0] fall_timer, next_fall_timer; // counts fall cycles

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK;
            direction  <= 1'b0;  // walk left on reset
            fall_timer <= 5'd0;
        end else begin
            state      <= next_state;
            direction  <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state logic
    always @* begin
        // defaults
        next_state      = state;
        next_direction  = direction;
        next_fall_timer = fall_timer;

        case(state)
            SPLAT: begin
                // Stay splatted forever, zero timer
                next_state = SPLAT;
                next_fall_timer = 5'd0;
                // direction unchanged
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
                    next_state = FALL;
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
                    // direction unchanged
                end
            end
            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    // direction unchanged
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
                    next_state = WALK;
                    next_fall_timer = 5'd0;
                    // Handle bump: bump_left causes walk right, bump_right causes walk left.
                    // Both bumps toggle direction.
                    if (bump_left & bump_right)
                        next_direction = ~direction;
                    else if (bump_left)
                        next_direction = 1'b1;
                    else if (bump_right)
                        next_direction = 1'b0;
                    else
                        next_direction = direction;
                end
            end
            default: begin
                next_state      = WALK;
                next_direction  = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Outputs (Moore)
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule