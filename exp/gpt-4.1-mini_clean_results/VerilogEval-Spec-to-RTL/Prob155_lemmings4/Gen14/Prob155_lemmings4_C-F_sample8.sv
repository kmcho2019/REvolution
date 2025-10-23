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

    // Mode encoding (2 bits)
    localparam MODE_WALK  = 2'd0;
    localparam MODE_DIG   = 2'd1;
    localparam MODE_FALL  = 2'd2;
    localparam MODE_SPLAT = 2'd3;

    // State register: [2:1] mode, [0] direction (0=left,1=right)
    reg [2:0] state, next_state;

    // Fall timer (5 bits), saturating at 21 for splat condition
    reg [4:0] fall_timer, next_fall_timer;

    wire [1:0] mode = state[2:1];
    wire direction = state[0];

    // Combined bump signals
    wire bump_any = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    // Splat threshold
    localparam FALL_TIMER_MAX = 5'd21;

    // Async reset and synchronous state update
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= {MODE_WALK, 1'b0}; // Walk left on reset
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state and timer logic
    always_comb begin
        next_state = state;
        next_fall_timer = fall_timer;

        case (mode)
            MODE_SPLAT: begin
                // Remain splatted forever, no timer counting needed
                next_state = state;
                next_fall_timer = 5'd0;
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed: check splat condition
                    if (fall_timer > FALL_TIMER_MAX) begin
                        next_state = {MODE_SPLAT, direction};
                    end else begin
                        next_state = {MODE_WALK, direction};
                    end
                    next_fall_timer = 5'd0;
                end else begin
                    // Continue falling, saturate timer at 21
                    next_state = state;
                    if (fall_timer < FALL_TIMER_MAX + 1)
                        next_fall_timer = fall_timer + 1'b1;
                    else
                        next_fall_timer = fall_timer;
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Ground lost during digging -> start falling
                    next_state = {MODE_FALL, direction};
                    next_fall_timer = 5'd1;
                end else begin
                    // Continue digging, ignore bumps and dig input
                    next_state = state;
                    next_fall_timer = 5'd0;
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    // Ground gone: start falling
                    next_state = {MODE_FALL, direction};
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    // Start digging only if walking on ground
                    next_state = {MODE_DIG, direction};
                    next_fall_timer = 5'd0;
                end else begin
                    // Walking on ground: handle bumps with priority
                    next_state = state;
                    next_fall_timer = 5'd0;
                    // Direction update
                    if (bump_both) begin
                        // Toggle direction if bumped on both sides
                        next_state[0] = ~direction;
                    end else if (bump_left) begin
                        // Bump on left: walk right
                        next_state[0] = 1'b1;
                    end else if (bump_right) begin
                        // Bump on right: walk left
                        next_state[0] = 1'b0;
                    end
                    // else no bump: maintain direction
                end
            end

            default: begin
                // Safe fallback to walk left
                next_state = {MODE_WALK, 1'b0};
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs depend on mode and direction only
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule