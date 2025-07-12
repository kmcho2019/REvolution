module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Define FSM states encoding walking, falling, and digging with direction
    typedef enum logic [2:0] {
        WALK_L = 3'd0,
        WALK_R = 3'd1,
        FALL_L = 3'd2,
        FALL_R = 3'd3,
        DIG_L  = 3'd4,
        DIG_R  = 3'd5
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            WALK_L: begin
                if (!ground)            next_state = FALL_L;         // fall priority
                else if (dig)          next_state = DIG_L;          // dig priority
                else if (bump_left || bump_right) begin            // bump priority
                    // bump left or right flips direction accordingly
                    // bump both means flip direction
                    if (bump_left && bump_right)
                        next_state = WALK_R;
                    else if (bump_left)
                        next_state = WALK_R;
                    else
                        next_state = WALK_L; // bump_right => walk left, so stays WALK_L
                end else
                    next_state = WALK_L;                             // keep walking left
            end

            WALK_R: begin
                if (!ground)            next_state = FALL_R;
                else if (dig)          next_state = DIG_R;
                else if (bump_left || bump_right) begin
                    if (bump_left && bump_right)
                        next_state = WALK_L;
                    else if (bump_right)
                        next_state = WALK_L;
                    else
                        next_state = WALK_R;
                end else
                    next_state = WALK_R;
            end

            FALL_L: begin
                if (ground)             next_state = WALK_L;          // ground back, resume walking left
                else                    next_state = FALL_L;          // continue falling left
            end

            FALL_R: begin
                if (ground)             next_state = WALK_R;          // ground back, resume walking right
                else                    next_state = FALL_R;
            end

            DIG_L: begin
                if (!ground)            next_state = FALL_L;          // fall when no ground
                else                    next_state = DIG_L;           // continue digging left
            end

            DIG_R: begin
                if (!ground)            next_state = FALL_R;
                else                    next_state = DIG_R;
            end

            default:                    next_state = WALK_L;         // default safe state
        endcase
    end

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_L;
        else
            state <= next_state;
    end

    // Outputs: mutually exclusive based on state (Moore)
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah       = (state == FALL_L) || (state == FALL_R);
    assign digging    = (state == DIG_L)  || (state == DIG_R);

endmodule