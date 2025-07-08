module TopModule (
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
    // State encoding
    typedef enum logic [2:0] {
        W_LEFT = 3'd0,
        W_RIGHT = 3'd1,
        D_LEFT = 3'd2,
        D_RIGHT = 3'd3,
        F_LEFT = 3'd4,
        F_RIGHT = 3'd5,
        SPLAT = 3'd6
    } state_t;

    state_t state, next_state;

    // Fall counter for falling duration
    logic [4:0] fall_counter; // enough to count >20

    // Outputs logic
    // Moore outputs depend on current state only
    assign walk_left  = (state == W_LEFT) || (state == D_LEFT);
    assign walk_right = (state == W_RIGHT) || (state == D_RIGHT);
    assign digging    = (state == D_LEFT) || (state == D_RIGHT);
    assign aaah       = (state == F_LEFT) || (state == F_RIGHT);

    // Next state logic and fall_counter update
    always_comb begin
        // Default next state is current state
        next_state = state;

        // Default next fall counter
        // Will update in sequential block
        // But for combinational decisions:
        // when falling, increment counter
        // else reset to zero

        case (state)
            SPLAT: begin
                // Once splatted, no transition
                next_state = SPLAT;
            end
            F_LEFT, F_RIGHT: begin
                // Falling state
                if (ground) begin
                    // Ground appeared, check fall duration
                    if (fall_counter > 5'd20) begin
                        next_state = SPLAT;
                    end else begin
                        // Resume walking in same direction
                        next_state = (state == F_LEFT) ? W_LEFT : W_RIGHT;
                    end
                end else begin
                    // Still falling
                    next_state = state;
                end
            end
            W_LEFT, W_RIGHT: begin
                // Walking states
                if (~ground) begin
                    // Ground lost - start falling in same direction
                    next_state = (state == W_LEFT) ? F_LEFT : F_RIGHT;
                end else if (dig) begin
                    // Start digging only if dig=1 and on ground and walking
                    next_state = (state == W_LEFT) ? D_LEFT : D_RIGHT;
                end else if (bump_left || bump_right) begin
                    // Switch direction on bump, bumps can be on either side or both
                    // If walking left and bump_left=1 or bump_right=1 switch direction
                    // Similarly for walking right
                    // According to spec, if bumped on left, walk right; if bumped on right, walk left
                    // If both bumped, still switch
                    if (bump_left && bump_right) begin
                        // Switch direction anyway
                        next_state = (state == W_LEFT) ? W_RIGHT : W_LEFT;
                    end else if (bump_left) begin
                        // bumped on left => walk right
                        next_state = W_RIGHT;
                    end else if (bump_right) begin
                        // bumped on right => walk left
                        next_state = W_LEFT;
                    end else begin
                        // No bump (should not occur here)
                        next_state = state;
                    end
                end else begin
                    // No event, remain walking same direction
                    next_state = state;
                end
            end
            D_LEFT, D_RIGHT: begin
                // Digging states
                if (~ground) begin
                    // Ground lost while digging => start falling same direction
                    next_state = (state == D_LEFT) ? F_LEFT : F_RIGHT;
                end else begin
                    // Continue digging
                    next_state = state;
                end
            end
            default: begin
                next_state = W_LEFT; // default fallback
            end
        endcase
    end

    // Sequential logic: state and fall_counter update
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= W_LEFT;
            fall_counter <= 5'd0;
        end else begin
            state <= next_state;

            // Update fall_counter:
            // If new state is falling, increment or reset counter accordingly
            if (next_state == F_LEFT || next_state == F_RIGHT) begin
                if (state == F_LEFT || state == F_RIGHT) begin
                    // continuing falling, increment counter
                    // saturate at max 31 to avoid overflow but spec doesn't limit upper fall
                    if (fall_counter < 5'd31) fall_counter <= fall_counter + 5'd1;
                end else begin
                    // just started falling, reset counter to 1 (first cycle falling)
                    fall_counter <= 5'd1;
                end
            end else begin
                // Not falling state, reset counter to zero
                fall_counter <= 5'd0;
            end
        end
    end
endmodule