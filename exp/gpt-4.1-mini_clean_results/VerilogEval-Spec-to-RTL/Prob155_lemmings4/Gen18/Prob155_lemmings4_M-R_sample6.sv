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

    // One-hot encoded states
    typedef enum logic [3:0] {
        WALK  = 4'b0001,
        DIG   = 4'b0010,
        FALL  = 4'b0100,
        SPLAT = 4'b1000
    } state_t;

    state_t state, next_state;

    // direction: 0=left, 1=right
    logic direction, next_direction;

    logic [4:0] fall_timer, next_fall_timer;

    // fall_too_long signal
    wire fall_too_long = (fall_timer > 5'd20);

    // Compute bump condition: bump on either or both sides
    wire bump = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    // Sequential logic with asynchronous posedge reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK;
            direction  <= 1'b0;   // walk left on reset
            fall_timer <= 5'd0;
        end else begin
            state      <= next_state;
            direction  <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Direction logic:
    // When walking and bumped, update direction based on bumps.
    // If both bumped, toggle direction.
    // Otherwise bump_left => walk right, bump_right => walk left.
    // While falling, digging, or splatted, direction remains unchanged.
    always_comb begin
        if (state == WALK) begin
            if (bump_both) begin
                next_direction = ~direction;
            end else if (bump_left) begin
                next_direction = 1'b1; // walk right
            end else if (bump_right) begin
                next_direction = 1'b0; // walk left
            end else begin
                next_direction = direction;
            end
        end else begin
            // keep direction unchanged in other states
            next_direction = direction;
        end
    end

    // Fall timer update logic
    always_comb begin
        if (state == FALL) begin
            if (ground) begin
                next_fall_timer = 5'd0;
            end else if (fall_timer == 5'd31) begin
                next_fall_timer = 5'd31; // saturate
            end else begin
                next_fall_timer = fall_timer + 5'd1;
            end
        end else begin
            next_fall_timer = 5'd0;
        end
    end

    // Next state logic using combinational assigns
    always_comb begin
        // default: hold state
        next_state = state;

        case (1'b1)
            // SPLAT state: remain splatted forever
            state == SPLAT: next_state = SPLAT;

            // FALL state logic
            state == FALL: begin
                if (ground) begin
                    if (fall_too_long)
                        next_state = SPLAT;
                    else
                        next_state = WALK;
                end else begin
                    next_state = FALL;
                end
            end

            // DIG state logic
            state == DIG: begin
                if (!ground)
                    next_state = FALL;
                else
                    next_state = DIG;
            end

            // WALK state logic
            state == WALK: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else begin
                    next_state = WALK;
                end
            end

            default: next_state = WALK; // fallback to WALK
        endcase
    end

    // Moore outputs derived from state and direction
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule