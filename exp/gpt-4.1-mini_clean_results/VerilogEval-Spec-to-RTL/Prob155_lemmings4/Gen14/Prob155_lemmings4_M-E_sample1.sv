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

    // State encoding
    typedef enum logic [1:0] {
        WALK = 2'b00,
        DIG  = 2'b01,
        FALL = 2'b10,
        SPLAT= 2'b11
    } state_t;

    state_t state, next_state;
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_count, next_fall_count; // count fall cycles (max 31)

    // Asynchronous reset with posedge areset and synchronous state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0;  // walk left
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            fall_count <= next_fall_count;
        end
    end

    // Next state and outputs logic
    always @(*) begin
        // Defaults: hold values
        next_state = state;
        next_direction = direction;
        next_fall_count = 5'd0;

        case(state)
            SPLAT: begin
                // Once splatted, remain here forever; outputs all zero
                next_state = SPLAT;
                next_direction = direction; // irrelevant, outputs zero
                next_fall_count = 5'd0;
            end

            FALL: begin
                if (ground) begin
                    // Landed after falling
                    if (fall_count > 5'd20)
                        next_state = SPLAT;
                    else
                        next_state = WALK;
                    // direction preserved
                    next_direction = direction;
                    next_fall_count = 5'd0;
                end else begin
                    // Still falling: increment count saturating at max 31
                    next_state = FALL;
                    next_direction = direction;
                    if (fall_count < 5'd31)
                        next_fall_count = fall_count + 1'b1;
                    else
                        next_fall_count = fall_count; // saturate
                end
            end

            WALK: begin
                if (!ground) begin
                    // Falling starts immediately on losing ground
                    next_state = FALL;
                    next_direction = direction; // keep direction
                    next_fall_count = 5'd1;
                end else if (dig) begin
                    // Start digging only if on ground and walking
                    next_state = DIG;
                    next_direction = direction;
                    next_fall_count = 5'd0;
                end else begin
                    // Check bumps to switch direction
                    // Bump on either side causes switch direction as per problem,
                    // bump on both sides also causes switch
                    if (bump_left || bump_right) begin
                        if (bump_left && bump_right) begin
                            next_direction = ~direction;
                        end else if (bump_left) begin
                            next_direction = 1'b1; // walk right
                        end else begin
                            next_direction = 1'b0; // walk left
                        end
                    end else begin
                        next_direction = direction;
                    end
                    next_state = WALK;
                    next_fall_count = 5'd0;
                end
            end

            DIG: begin
                if (!ground) begin
                    // Digging leads to falling if no ground underfoot
                    next_state = FALL;
                    next_direction = direction;
                    next_fall_count = 5'd1;
                end else begin
                    // Keep digging
                    next_state = DIG;
                    next_direction = direction;
                    next_fall_count = 5'd0;
                end
            end

            default: begin
                // Should never happen, default to WALK left
                next_state = WALK;
                next_direction = 1'b0;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Outputs: Moore machine style
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule