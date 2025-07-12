module TopModule (
    input  logic clk,
    input  logic areset,
    input  logic bump_left,
    input  logic bump_right,
    input  logic ground,
    input  logic dig,
    output logic walk_left,
    output logic walk_right,
    output logic aaah,
    output logic digging
);

    // State encoding: 3 bits total - [2] = state, [1:0] = direction or special
    // Use separate parameters for clarity
    typedef enum logic [1:0] {
        DIR_LEFT  = 2'b00,
        DIR_RIGHT = 2'b01
    } direction_t;

    typedef enum logic [2:0] {
        WALK_LEFT  = 3'b000, // 0: walking left
        WALK_RIGHT = 3'b001, // 1: walking right
        DIG_LEFT   = 3'b010, // 2: digging left
        DIG_RIGHT  = 3'b011, // 3: digging right
        FALL_LEFT  = 3'b100, // 4: falling left
        FALL_RIGHT = 3'b101, // 5: falling right
        SPLAT      = 3'b110  // 6: splatted, direction irrelevant
    } state_dir_t;

    state_dir_t state, next_state;

    // Fall timer: 5 bits to count fall duration
    logic [4:0] fall_timer, next_fall_timer;

    // Helpers to extract direction from state
    function direction_t get_direction(state_dir_t s);
        case(s)
            WALK_LEFT, DIG_LEFT, FALL_LEFT: get_direction = DIR_LEFT;
            WALK_RIGHT, DIG_RIGHT, FALL_RIGHT: get_direction = DIR_RIGHT;
            default: get_direction = DIR_LEFT; // default direction for SPLAT
        endcase
    endfunction

    // Helpers to get walk/dig/fall bits
    function logic is_walking(state_dir_t s);
        is_walking = (s == WALK_LEFT) || (s == WALK_RIGHT);
    endfunction

    function logic is_digging(state_dir_t s);
        is_digging = (s == DIG_LEFT) || (s == DIG_RIGHT);
    endfunction

    function logic is_falling(state_dir_t s);
        is_falling = (s == FALL_LEFT) || (s == FALL_RIGHT);
    endfunction

    // Combine bump inputs for convenience
    logic bump_both = bump_left & bump_right;
    logic bump_either = bump_left | bump_right;

    // Splat condition: fall_timer > 20
    logic splat_condition = (fall_timer > 5'd20);

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT; // Start walking left on reset
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;

            // Update fall_timer: increment only when falling (and saturate at 31)
            if (is_falling(next_state)) begin
                if (fall_timer == 5'd31)
                    fall_timer <= fall_timer;
                else
                    fall_timer <= fall_timer + 5'd1;
            end else begin
                fall_timer <= 5'd0;
            end
        end
    end

    // Next state and outputs combinational logic
    always_comb begin
        next_state = state;

        // Extract current direction for use in next states
        direction_t dir = get_direction(state);

        case(state)
            SPLAT: begin
                // Once splatted, remain splatted forever
                next_state = SPLAT;
            end

            FALL_LEFT, FALL_RIGHT: begin
                if (ground) begin
                    // Landed on ground, check splat
                    if (splat_condition) begin
                        next_state = SPLAT;
                    end else begin
                        // Resume walking in same direction
                        next_state = (state == FALL_LEFT) ? WALK_LEFT : WALK_RIGHT;
                    end
                end else begin
                    // Keep falling in same direction
                    next_state = state;
                end
            end

            WALK_LEFT, WALK_RIGHT: begin
                if (!ground) begin
                    // Ground lost: start falling in same direction
                    next_state = (state == WALK_LEFT) ? FALL_LEFT : FALL_RIGHT;
                end else if (dig) begin
                    // Start digging only if on ground and not falling
                    next_state = (state == WALK_LEFT) ? DIG_LEFT : DIG_RIGHT;
                end else begin
                    // Still walking on ground; handle bump priority
                    if (bump_both) begin
                        // Switch direction if bumped on both sides
                        next_state = (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
                    end else if (bump_left) begin
                        // Bumped left: walk right
                        next_state = WALK_RIGHT;
                    end else if (bump_right) begin
                        // Bumped right: walk left
                        next_state = WALK_LEFT;
                    end else begin
                        // Continue walking same direction
                        next_state = state;
                    end
                end
            end

            DIG_LEFT, DIG_RIGHT: begin
                if (!ground) begin
                    // Falling after digging if ground disappears
                    next_state = (state == DIG_LEFT) ? FALL_LEFT : FALL_RIGHT;
                end else begin
                    // Continue digging on ground
                    next_state = state;
                end
            end

            default: begin
                // Default fallback: walk left
                next_state = WALK_LEFT;
            end
        endcase
    end

    // Moore outputs based on current state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = is_falling(state);
    assign digging    = is_digging(state);

endmodule