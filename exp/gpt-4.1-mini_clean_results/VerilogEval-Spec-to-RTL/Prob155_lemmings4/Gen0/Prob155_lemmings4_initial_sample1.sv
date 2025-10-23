module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State encoding
    typedef enum logic [2:0] {
        WALK_LEFT  = 3'b000,
        WALK_RIGHT = 3'b001,
        FALL_LEFT  = 3'b010,
        FALL_RIGHT = 3'b011,
        DIG_LEFT   = 3'b100,
        DIG_RIGHT  = 3'b101,
        SPLATTER   = 3'b110
    } state_t;

    state_t state, next_state;

    reg [4:0] fall_counter; // 5 bits to count up to >20

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 5'd0;
        end else begin
            state <= next_state;
            // Increment fall counter if falling, else reset
            if (state == FALL_LEFT || state == FALL_RIGHT) begin
                fall_counter <= fall_counter + 1'b1;
            end else begin
                fall_counter <= 5'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        // Defaults
        next_state = state;

        // SPLATTER is absorbing state
        if (state == SPLATTER) begin
            next_state = SPLATTER;
        end else begin
            // Extract walking direction for convenience:
            // Walk left: WALK_LEFT, FALL_LEFT, DIG_LEFT
            // Walk right: WALK_RIGHT, FALL_RIGHT, DIG_RIGHT

            // Determine current walking direction (for falling, digging and walking states)
            logic walk_dir_left;
            walk_dir_left = (state == WALK_LEFT) || (state == FALL_LEFT) || (state == DIG_LEFT);

            // Priority: fall > dig > bump if walking on ground

            // FALL condition: ground=0 and not already falling or splattered
            // If currently not falling, and ground=0, fall starts
            // Note: if currently digging or walking on ground
            if ((state == WALK_LEFT || state == WALK_RIGHT || state == DIG_LEFT || state == DIG_RIGHT) && (ground == 1'b0)) begin
                // transition to fall state in same direction
                next_state = walk_dir_left ? FALL_LEFT : FALL_RIGHT;
            end else if (state == FALL_LEFT || state == FALL_RIGHT) begin
                // falling and ground=1 means landed
                if (ground == 1'b1) begin
                    // check if splatter condition met
                    if (fall_counter > 5'd20) begin
                        next_state = SPLATTER;
                    end else begin
                        // resume walking same direction as falling
                        next_state = (state == FALL_LEFT) ? WALK_LEFT : WALK_RIGHT;
                    end
                end else begin
                    // still falling, remain falling
                    next_state = state;
                end
            end else if (state == DIG_LEFT || state == DIG_RIGHT) begin
                // If digging and ground disappears, transition to fall
                if (ground == 1'b0) begin
                    next_state = (state == DIG_LEFT) ? FALL_LEFT : FALL_RIGHT;
                end else begin
                    // continue digging while ground=1
                    next_state = state;
                end
            end else if (state == WALK_LEFT || state == WALK_RIGHT) begin
                // walking on ground, ground=1
                // dig condition has priority over bump
                if (dig == 1'b1 && ground == 1'b1) begin
                    // start digging in current direction
                    next_state = walk_dir_left ? DIG_LEFT : DIG_RIGHT;
                end else begin
                    // bump condition (change direction)
                    if (bump_left && bump_right) begin
                        // bumped both sides => switch direction
                        next_state = walk_dir_left ? WALK_RIGHT : WALK_LEFT;
                    end else if (bump_left) begin
                        // bumped left => walk right
                        next_state = WALK_RIGHT;
                    end else if (bump_right) begin
                        // bumped right => walk left
                        next_state = WALK_LEFT;
                    end else begin
                        // no bump => keep walking same direction
                        next_state = state;
                    end
                end
            end else begin
                // default catch-all (should not occur)
                next_state = state;
            end
        end
    end

    // Output logic: Moore machine, outputs depend only on state
    always @(*) begin
        // Default outputs all zero
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case (state)
            WALK_LEFT: begin
                walk_left = 1'b1;
            end
            WALK_RIGHT: begin
                walk_right = 1'b1;
            end
            FALL_LEFT, FALL_RIGHT: begin
                aaah = 1'b1;
            end
            DIG_LEFT: begin
                digging = 1'b1;
                walk_left = 1'b1;
            end
            DIG_RIGHT: begin
                digging = 1'b1;
                walk_right = 1'b1;
            end
            SPLATTER: begin
                // all outputs zero
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
            default: begin
                // should not happen
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
        endcase
    end

endmodule