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

    typedef enum logic [1:0] {
        WALK = 2'd0,
        DIG  = 2'd1,
        FALL = 2'd2,
        SPLAT= 2'd3
    } state_t;

    state_t state, next_state;
    logic direction, next_direction; // 0 = left, 1 = right
    logic [4:0] fall_count, next_fall_count;

    // Async reset and state register update
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // Walk left initially
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            fall_count <= next_fall_count;
        end
    end

    // Next state and outputs logic
    always_comb begin
        // Defaults to current values
        next_state = state;
        next_direction = direction;
        next_fall_count = fall_count;

        case (state)
            SPLAT: begin
                // Forever splatted; no outputs active
                next_state = SPLAT;
            end

            FALL: begin
                if (ground) begin
                    // Landed
                    if (fall_count > 5'd20)
                        next_state = SPLAT;
                    else
                        next_state = WALK;
                    next_fall_count = 5'd0;
                    // direction unchanged on landing
                end else begin
                    // Still falling: increment timer (saturate at 31)
                    next_fall_count = (fall_count < 5'd31) ? fall_count + 1'b1 : 5'd31;
                end
                next_direction = direction;
            end

            WALK: begin
                if (!ground) begin
                    // Start falling when no ground
                    next_state = FALL;
                    next_fall_count = 5'd1;
                end else if (dig) begin
                    // Start digging only if on ground and walking
                    next_state = DIG;
                end else if (bump_left && bump_right) begin
                    // Both bumps: toggle direction
                    next_direction = ~direction;
                end else if (bump_left) begin
                    // Bumped left: walk right
                    next_direction = 1'b1;
                end else if (bump_right) begin
                    // Bumped right: walk left
                    next_direction = 1'b0;
                end
                // else direction stays the same
                next_fall_count = 5'd0;
            end

            DIG: begin
                if (!ground) begin
                    // Digging and ground lost: start falling
                    next_state = FALL;
                    next_fall_count = 5'd1;
                end else begin
                    // Continue digging while ground present
                    next_fall_count = 5'd0;
                    // direction unchanged during digging
                end
                next_direction = direction;
            end

            default: begin
                next_state = WALK;
                next_direction = 1'b0;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Outputs
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule