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

    // State encoding using parameters (3 bits)
    parameter WALK_LEFT  = 3'd0,
              WALK_RIGHT = 3'd1,
              FALL_LEFT  = 3'd2,
              FALL_RIGHT = 3'd3,
              DIG_LEFT   = 3'd4,
              DIG_RIGHT  = 3'd5,
              SPLATTERED = 3'd6;

    reg [2:0] state, next_state;
    reg [4:0] fall_count; // 5 bits to count up to >20

    // Convenience signals to decode current state
    wire falling = (state == FALL_LEFT) || (state == FALL_RIGHT);
    wire digging_state = (state == DIG_LEFT) || (state == DIG_RIGHT);
    wire walking_left = (state == WALK_LEFT);
    wire walking_right = (state == WALK_RIGHT);
    wire walking = walking_left || walking_right;

    // Next state logic (Moore) with explicit prioritization
    always @(*) begin
        next_state = state; // default hold

        case(state)
            // WALKING states
            WALK_LEFT: begin
                if (ground == 1) begin
                    // priority 1: dig if requested
                    if (dig) begin
                        next_state = DIG_LEFT;
                    end else begin
                        // priority 2: bump input handling
                        // bump_left means bumped on left, so walk right
                        if (bump_left) begin
                            next_state = WALK_RIGHT;
                        end else if (bump_right) begin
                            // bumped on right, so walk left again (same direction)
                            // no change
                            next_state = WALK_LEFT;
                        end else begin
                            next_state = WALK_LEFT;
                        end
                    end
                end else begin
                    // ground disappeared, start falling left
                    // bump inputs ignored for falling start
                    next_state = FALL_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (ground == 1) begin
                    if (dig) begin
                        next_state = DIG_RIGHT;
                    end else begin
                        // bump inputs: bump_left causes walk right (same direction), bump_right causes walk left (switch)
                        if (bump_right) begin
                            next_state = WALK_LEFT;
                        end else if (bump_left) begin
                            // bumped on left, walk right (same)
                            next_state = WALK_RIGHT;
                        end else begin
                            next_state = WALK_RIGHT;
                        end
                    end
                end else begin
                    // ground gone, start falling right
                    next_state = FALL_RIGHT;
                end
            end

            // DIGGING states
            DIG_LEFT: begin
                if (ground == 0) begin
                    // no ground under digging: fall left
                    next_state = FALL_LEFT;
                end else begin
                    // continue digging
                    next_state = DIG_LEFT;
                end
            end

            DIG_RIGHT: begin
                if (ground == 0) begin
                    next_state = FALL_RIGHT;
                end else begin
                    next_state = DIG_RIGHT;
                end
            end

            // FALLING states
            FALL_LEFT: begin
                if (ground == 1) begin
                    // landed after fall - check fall count to splatter or walk
                    if (fall_count > 5'd20) begin
                        next_state = SPLATTERED;
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end else begin
                    // still falling
                    next_state = FALL_LEFT;
                end
            end

            FALL_RIGHT: begin
                if (ground == 1) begin
                    if (fall_count > 5'd20) begin
                        next_state = SPLATTERED;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end else begin
                    next_state = FALL_RIGHT;
                end
            end

            SPLATTERED: begin
                // no transitions until reset
                next_state = SPLATTERED;
            end

            default: begin
                // safety fallback
                next_state = WALK_LEFT;
            end
        endcase
    end


    // State register and fall count
    // async positive edge reset to WALK_LEFT and clear fall count
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 5'd0;
        end else begin
            state <= next_state;

            if (falling) begin
                if (ground == 0) begin
                    // increment fall counter while falling and in air
                    fall_count <= fall_count + 5'd1;
                end else begin
                    // landed, reset fall_count next cycle
                    fall_count <= 5'd0;
                end
            end else begin
                // reset counter when not falling
                fall_count <= 5'd0;
            end
        end
    end

    // Outputs: Moore style based on current state
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
            DIG_LEFT: begin
                walk_left = 1'b1;
                digging = 1'b1;
            end
            DIG_RIGHT: begin
                walk_right = 1'b1;
                digging = 1'b1;
            end
            FALL_LEFT, FALL_RIGHT: begin
                aaah = 1'b1;
            end
            SPLATTERED: begin
                // all outputs zero
            end
        endcase
    end

endmodule