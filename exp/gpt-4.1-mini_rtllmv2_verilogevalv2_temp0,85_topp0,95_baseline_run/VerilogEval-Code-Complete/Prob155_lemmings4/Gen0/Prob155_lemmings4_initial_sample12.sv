module TopModule (
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
        WALK_LEFT    = 3'd0,
        WALK_RIGHT   = 3'd1,
        FALLING_LEFT = 3'd2,
        FALLING_RIGHT= 3'd3,
        DIGGING_LEFT = 3'd4,
        DIGGING_RIGHT= 3'd5,
        SPLATTERED   = 3'd6
    } state_t;

    state_t state, next_state;

    // Falling duration counter
    logic [4:0] fall_counter; // max 31

    // Helper signals for bump
    logic bumped;

    assign bumped = bump_left | bump_right;

    // Next state logic combinational
    always_comb begin
        // Default next state same as current
        next_state = state;

        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    // Fall has precedence
                    next_state = FALLING_LEFT;
                end else if (dig) begin
                    // Dig if ground and dig=1
                    next_state = DIGGING_LEFT;
                end else if (bumped) begin
                    // Switch direction on bump
                    // Bump on left or right or both => flip direction
                    next_state = WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING_RIGHT;
                end else if (dig) begin
                    next_state = DIGGING_RIGHT;
                end else if (bumped) begin
                    next_state = WALK_LEFT;
                end
            end
            FALLING_LEFT: begin
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        next_state = SPLATTERED;
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end
                // else remain falling
            end
            FALLING_RIGHT: begin
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        next_state = SPLATTERED;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end
            end
            DIGGING_LEFT: begin
                if (!ground) begin
                    next_state = FALLING_LEFT;
                end
                // else remain digging
            end
            DIGGING_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING_RIGHT;
                end
            end
            SPLATTERED: begin
                // Remain forever
                next_state = SPLATTERED;
            end
            default: next_state = WALK_LEFT; // default safety
        endcase
    end

    // Fall counter logic & state update (synchronous with async reset)
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 5'd0;
        end else begin
            state <= next_state;
            // Update fall counter
            if ((next_state == FALLING_LEFT) || (next_state == FALLING_RIGHT)) begin
                fall_counter <= fall_counter + 5'd1;
            end else begin
                fall_counter <= 5'd0;
            end
        end
    end

    // Output logic (Moore machine: outputs depend on state only)
    always_comb begin
        // Default outputs all zero
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
            FALLING_LEFT, FALLING_RIGHT: begin
                aaah = 1'b1;
            end
            DIGGING_LEFT: begin
                digging = 1'b1;
                walk_left = 1'b1;
            end
            DIGGING_RIGHT: begin
                digging = 1'b1;
                walk_right = 1'b1;
            end
            SPLATTERED: begin
                // all zero
            end
        endcase
    end

endmodule