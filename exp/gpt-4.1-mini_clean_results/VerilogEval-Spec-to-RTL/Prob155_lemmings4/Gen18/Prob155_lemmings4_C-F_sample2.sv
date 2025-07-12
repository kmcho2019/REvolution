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

    // State encoding includes direction in LSB:
    // [2:1] = main state: 2'b00=WALK,2'b01=DIG,2'b10=FALL,2'b11=SPLAT
    // [0] = direction: 0=left, 1=right (valid only in WALK and DIG states)
    typedef enum logic [2:0] {
        WALK_LEFT  = 3'b000,
        WALK_RIGHT = 3'b001,
        DIG_LEFT   = 3'b010,
        DIG_RIGHT  = 3'b011,
        FALL_LEFT  = 3'b100,
        FALL_RIGHT = 3'b101,
        SPLAT_LR   = 3'b110, // direction irrelevant in SPLAT
        SPLAT_XX   = 3'b111  // unused but keep for safety
    } state_t;

    state_t state, next_state;
    logic [4:0] fall_timer, next_fall_timer; // 5-bit saturating counter

    // Extract main state and direction for convenience
    wire [1:0] main_state = state[2:1];
    wire       direction  = state[0]; // 0=left,1=right; undefined in SPLAT

    wire bump = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    // Constants for main states
    localparam WALK = 2'b00;
    localparam DIG  = 2'b01;
    localparam FALL = 2'b10;
    localparam SPLAT= 2'b11;

    // Async reset and synchronous update
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    always_comb begin
        // Defaults to hold current
        next_state = state;
        next_fall_timer = fall_timer;

        case(main_state)
            SPLAT: begin
                // Remain splatted forever
                next_state = state;
                next_fall_timer = 5'd0;
            end
            FALL: begin
                if (ground) begin
                    // Landed; check splat condition
                    if (fall_timer > 5'd20) begin
                        next_state = SPLAT_LR; // direction irrelevant
                        next_fall_timer = 5'd0;
                    end else begin
                        // Return to WALK with same direction
                        next_state = (direction == 1'b0) ? WALK_LEFT : WALK_RIGHT;
                        next_fall_timer = 5'd0;
                    end
                end else begin
                    // Still falling, saturate at 31
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 5'd1;
                    next_state = state; // direction preserved in FALL state encoding
                end
            end
            WALK: begin
                if (!ground) begin
                    // Start falling; keep direction
                    next_state = (direction == 1'b0) ? FALL_LEFT : FALL_RIGHT;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    // Start digging, keep direction
                    next_state = (direction == 1'b0) ? DIG_LEFT : DIG_RIGHT;
                    next_fall_timer = 5'd0;
                end else begin
                    // Still walking on ground - handle bumps
                    next_fall_timer = 5'd0;
                    if (bump_both) begin
                        // flip direction
                        next_state = (direction == 1'b0) ? WALK_RIGHT : WALK_LEFT;
                    end else if (bump_left) begin
                        // bumped left => walk right
                        next_state = WALK_RIGHT;
                    end else if (bump_right) begin
                        // bumped right => walk left
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = state; // keep current direction
                    end
                end
            end
            DIG: begin
                if (!ground) begin
                    // ground lost => fall, keep direction
                    next_state = (direction == 1'b0) ? FALL_LEFT : FALL_RIGHT;
                    next_fall_timer = 5'd1;
                end else begin
                    // continue digging on ground
                    next_state = state;
                    next_fall_timer = 5'd0;
                end
            end
            default: begin
                // Safety fallback to walking left
                next_state = WALK_LEFT;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Outputs are Moore - depend only on current state

    assign walk_left  = (main_state == WALK) && (direction == 1'b0);
    assign walk_right = (main_state == WALK) && (direction == 1'b1);
    assign aaah       = (main_state == FALL);
    assign digging    = (main_state == DIG);

endmodule