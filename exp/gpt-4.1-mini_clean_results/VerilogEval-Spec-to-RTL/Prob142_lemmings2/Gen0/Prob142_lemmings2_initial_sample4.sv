module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

    typedef enum logic [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    state_t state, next_state;

    // Track walking direction before falling to resume after fall
    state_t walk_dir_before_fall;

    // State register with asynchronous active high reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walk_dir_before_fall <= WALK_LEFT;
        end else begin
            state <= next_state;

            // Update walk_dir_before_fall if changing walking direction and not falling
            if ((state == WALK_LEFT || state == WALK_RIGHT) && (next_state == WALK_LEFT || next_state == WALK_RIGHT)) begin
                walk_dir_before_fall <= next_state;
            end
        end
    end

    // Next state logic
    always_comb begin
        next_state = state;

        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    // ground disappeared, start falling
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // bumped on left or right or both: switch direction
                    next_state = WALK_RIGHT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end
            end

            FALLING: begin
                if (ground) begin
                    // ground returned, resume walking in previous direction
                    next_state = walk_dir_before_fall;
                end
                // While falling, bumps do not change anything
            end

            default: next_state = WALK_LEFT; // default safe state
        endcase
    end

    // Outputs: Moore FSM
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);

endmodule