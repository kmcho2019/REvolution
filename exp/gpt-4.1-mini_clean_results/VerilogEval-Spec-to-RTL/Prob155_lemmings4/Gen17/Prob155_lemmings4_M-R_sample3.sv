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

    // State encoding - one-hot style for clarity
    typedef struct packed {
        logic walk;   // walking state
        logic dig;    // digging state
        logic fall;   // falling state
        logic splat;  // splatted state
    } state_bits_t;

    // State registers
    state_bits_t state, next_state;

    // Direction register: 0 = left, 1 = right
    logic direction, next_direction;

    // 5-bit fall timer with saturation
    logic [4:0] fall_timer, next_fall_timer;

    // Internal signals for bump and direction change
    logic bump_any;
    logic bump_both;
    logic direction_flip;

    // Determine bump conditions
    assign bump_any  = bump_left | bump_right;
    assign bump_both = bump_left & bump_right;

    // Direction flip logic on bump in WALK state only
    // According to spec:
    // Both bumps => flip direction
    // bump_left only => walk right (direction=1)
    // bump_right only => walk left (direction=0)
    // no bump => keep direction
    always_comb begin
        if (bump_both) begin
            direction_flip = 1'b1;
        end else begin
            direction_flip = 1'b0;
        end
    end

    // Next direction combinational logic
    always_comb begin
        next_direction = direction; // default hold

        if (state.walk) begin
            if (bump_both) begin
                next_direction = ~direction;
            end else if (bump_left) begin
                next_direction = 1'b1;  // walk right
            end else if (bump_right) begin
                next_direction = 1'b0;  // walk left
            end
        end
        // No direction change in other states
    end

    // Fall timer enable: increment only in fall state and if timer < 31
    wire fall_timer_enable = state.fall && (fall_timer != 5'd31);

    // Compute next fall timer
    always_comb begin
        if (!state.fall)
            next_fall_timer = 5'd0;
        else if (fall_timer_enable)
            next_fall_timer = fall_timer + 5'd1;
        else
            next_fall_timer = fall_timer;
    end

    // Fall too long signal
    wire fall_too_long = (fall_timer > 5'd20);

    // Next state logic
    always_comb begin
        // Default to hold current state bits
        next_state = state;

        // Prioritize fall > dig > bump direction changes in walk state

        if (state.splat) begin
            // Remain splatted forever
            next_state = state;
        end else if (state.fall) begin
            if (ground) begin
                // Landed on ground from fall
                if (fall_too_long)
                    next_state = '{walk:0, dig:0, fall:0, splat:1};
                else
                    next_state = '{walk:1, dig:0, fall:0, splat:0};
            end else begin
                // Continue falling
                next_state = '{walk:0, dig:0, fall:1, splat:0};
            end
        end else if (state.dig) begin
            if (!ground) begin
                // Lost ground while digging -> fall
                next_state = '{walk:0, dig:0, fall:1, splat:0};
            end else begin
                // Continue digging
                next_state = '{walk:0, dig:1, fall:0, splat:0};
            end
        end else if (state.walk) begin
            if (!ground) begin
                // Start falling
                next_state = '{walk:0, dig:0, fall:1, splat:0};
            end else if (dig) begin
                // Start digging
                next_state = '{walk:0, dig:1, fall:0, splat:0};
            end else begin
                // Remain walking, direction changes via direction register
                next_state = '{walk:1, dig:0, fall:0, splat:0};
            end
        end else begin
            // Default safe state: start walking left
            next_state = '{walk:1, dig:0, fall:0, splat:0};
        end
    end

    // Sequential logic for state, direction, and fall_timer
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            // On reset, walk left, timer zero, no splat/dig/fall
            state.walk <= 1'b1;
            state.dig  <= 1'b0;
            state.fall <= 1'b0;
            state.splat<= 1'b0;
            direction  <= 1'b0; // left
            fall_timer <= 5'd0;
        end else begin
            state     <= next_state;
            direction <= next_direction;
            fall_timer<= next_fall_timer;
        end
    end

    // Moore outputs
    assign walk_left  = state.walk && (direction == 1'b0);
    assign walk_right = state.walk && (direction == 1'b1);
    assign aaah       = state.fall;
    assign digging    = state.dig;

endmodule