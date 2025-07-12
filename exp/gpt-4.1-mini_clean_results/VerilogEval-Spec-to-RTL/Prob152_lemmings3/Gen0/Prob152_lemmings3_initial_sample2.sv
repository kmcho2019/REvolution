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

    // Define states
    typedef enum reg [2:0] {
        WALK_LEFT  = 3'd0,
        WALK_RIGHT = 3'd1,
        FALL       = 3'd2,
        DIG_LEFT   = 3'd3,
        DIG_RIGHT  = 3'd4
    } state_t;

    state_t state, next_state;

    // Register to store walking direction before falling
    reg prev_walk_left;

    // Next state logic (combinational)
    always @(*) begin
        // Default next state is current state
        next_state = state;

        case (state)
            WALK_LEFT: begin
                if (~ground) begin
                    // Fall has priority
                    next_state = FALL;
                end else if (dig) begin
                    // Dig if dig=1 and on ground and walking
                    next_state = DIG_LEFT;
                end else if (bump_left || bump_right) begin
                    // Switch direction if bumped left or right (or both)
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (~ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG_RIGHT;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALL: begin
                if (ground) begin
                    // Resume previous walking direction after fall ends
                    next_state = prev_walk_left ? WALK_LEFT : WALK_RIGHT;
                end else begin
                    next_state = FALL;
                end
            end

            DIG_LEFT: begin
                if (~ground) begin
                    // When ground disappears while digging, start falling
                    next_state = FALL;
                end else begin
                    // Continue digging while ground present
                    next_state = DIG_LEFT;
                end
            end

            DIG_RIGHT: begin
                if (~ground) begin
                    next_state = FALL;
                end else begin
                    next_state = DIG_RIGHT;
                end
            end

            default: next_state = WALK_LEFT; // Default safe state
        endcase
    end

    // Sequential logic - state updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            prev_walk_left <= 1'b1;
        end else begin
            // Update prev_walk_left on walking states only
            // Falling and digging do not update direction storage
            if ((state == WALK_LEFT) || (state == WALK_RIGHT)) begin
                prev_walk_left <= (state == WALK_LEFT);
            end

            state <= next_state;
        end
    end

    // Output logic (Moore)
    always @(*) begin
        // default outputs 0
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case(state)
            WALK_LEFT: begin
                walk_left = 1'b1;
            end
            WALK_RIGHT: begin
                walk_right = 1'b1;
            end
            FALL: begin
                aaah = 1'b1;
            end
            DIG_LEFT: begin
                walk_left = 1'b1;
                digging = 1'b1;
            end
            DIG_RIGHT: begin
                walk_right = 1'b1;
                digging = 1'b1;
            end
        endcase
    end

endmodule