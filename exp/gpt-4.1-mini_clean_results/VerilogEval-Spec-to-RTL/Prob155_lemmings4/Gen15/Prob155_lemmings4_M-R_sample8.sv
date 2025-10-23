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

    // State encoding using parameters (one-hot style not strictly one-hot, but distinct values)
    localparam WALK  = 2'd0;
    localparam DIG   = 2'd1;
    localparam FALL  = 2'd2;
    localparam SPLAT = 2'd3;

    reg [1:0] state, next_state;
    reg       direction, next_direction;  // 0 = left, 1 = right

    // Fall timer 5-bit counter and enable signal
    reg [4:0] fall_timer;
    wire fall_timer_en;

    // Next fall timer value combinationally
    wire [4:0] fall_timer_inc = (fall_timer == 5'd31) ? 5'd31 : (fall_timer + 1'b1);
    wire fall_too_long = (fall_timer > 5'd20);

    // Bump logic: bumps cause direction toggle if both sides or one side bump
    wire bumped_both = bump_left & bump_right;

    // Sequential logic: state, direction, fall_timer registers with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK;
            direction  <= 1'b0;  // walk left on reset
            fall_timer <= 5'd0;
        end else begin
            state      <= next_state;
            direction  <= next_direction;
            // fall_timer increments only when enabled
            if (fall_timer_en)
                fall_timer <= fall_timer_inc;
            else
                fall_timer <= 5'd0;
        end
    end

    // Next state logic
    // Priorities: fall > dig > bump direction > hold
    always @* begin
        next_state = state;
        next_direction = direction;
    end

    // Next state combinational assign block separated for clarity
    always @* begin
        case(state)
            SPLAT: begin
                // Forever splatted, no changes
                next_state     = SPLAT;
                next_direction = direction;
            end

            FALL: begin
                if (ground) begin
                    // Landed
                    if (fall_too_long) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = WALK;
                    end
                    next_direction = direction;
                end else begin
                    // Continue falling
                    next_state = FALL;
                    next_direction = direction;
                end
            end

            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                    next_direction = direction;
                end else begin
                    next_state = DIG;
                    next_direction = direction;
                end
            end

            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                    next_direction = direction;
                end else if (dig) begin
                    next_state = DIG;
                    next_direction = direction;
                end else begin
                    next_state = WALK;
                    // Direction changes due to bumps
                    if (bumped_both)
                        next_direction = ~direction;
                    else if (bump_left)
                        next_direction = 1'b1;  // bumped left -> walk right
                    else if (bump_right)
                        next_direction = 1'b0;  // bumped right -> walk left
                    else
                        next_direction = direction;
                end
            end

            default: begin
                next_state = WALK;
                next_direction = 1'b0;
            end
        endcase
    end

    // fall_timer enable only when FALL state and not landed yet
    assign fall_timer_en = (state == FALL) && (!ground);

    // Moore outputs derived from registered state and direction
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule