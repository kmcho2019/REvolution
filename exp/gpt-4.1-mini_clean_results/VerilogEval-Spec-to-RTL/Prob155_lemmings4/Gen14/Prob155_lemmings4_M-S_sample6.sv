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
    localparam WALK = 2'b00;
    localparam DIG  = 2'b01;
    localparam FALL = 2'b10;
    localparam SPLAT= 2'b11;

    reg [1:0] state, next_state;
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer;

    wire bump = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // walk left
            fall_timer <= 0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    always @(*) begin
        // defaults
        next_state = state;
        next_direction = direction;
        next_fall_timer = fall_timer;

        case(state)
            SPLAT: begin
                // Remain splat forever
                next_state = SPLAT;
                next_fall_timer = 0;
                // direction unchanged
            end
            FALL: begin
                if (ground) begin
                    // Landed: splat if fallen > 20 cycles
                    if (fall_timer > 20) begin
                        next_state = SPLAT;
                        next_fall_timer = 0;
                    end else begin
                        next_state = WALK;
                        next_fall_timer = 0;
                    end
                end else begin
                    // Continue falling, saturate at max 31
                    next_fall_timer = (fall_timer == 31) ? 31 : fall_timer + 1;
                end
                next_direction = direction; // direction unchanged during fall
            end
            WALK: begin
                if (!ground) begin
                    // Fall starts
                    next_state = FALL;
                    next_fall_timer = 1;
                end else if (dig) begin
                    // Start digging
                    next_state = DIG;
                    next_fall_timer = 0;
                end else begin
                    // Walk and possibly change direction on bump
                    next_fall_timer = 0;
                    next_state = WALK;
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
            DIG: begin
                if (!ground) begin
                    // ground lost, start falling
                    next_state = FALL;
                    next_fall_timer = 1;
                end else begin
                    // keep digging
                    next_state = DIG;
                    next_fall_timer = 0;
                end
                next_direction = direction;
            end
            default: begin
                // default fallback: walk left
                next_state = WALK;
                next_direction = 0;
                next_fall_timer = 0;
            end
        endcase
    end

    // Outputs (Moore)
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule