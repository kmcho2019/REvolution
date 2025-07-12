module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // State encoding
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'd0,
        WALK_RIGHT = 2'd1,
        FALLING    = 2'd2
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        // Default keep current state
        next_state = state;

        case (state)
            WALK_LEFT: begin
                if (ground == 1'b0) begin
                    // Start falling, keep direction encoded in FALLING
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // Bump causes switch direction to right
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (ground == 1'b0) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // Bump causes switch direction to left
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALLING: begin
                if (ground == 1'b1) begin
                    // Land and resume walking in stored direction
                    // Stored direction is encoded in the FALLING state itself
                    // Must remember which direction FALLING corresponds to;
                    // So FALLING state represents falling while last walking direction is left or right?
                    // Problem states keep walking direction as before falling.
                    // So FALLING must remember direction.

                    // We only have one FALLING state, so to know which walking direction to go back to,
                    // let's add a separate reg to store direction at falling start.

                    // But the problem states to implement a Moore FSM with no extra state bits.
                    // So to implement this cleanly, FALLING needs to store the last direction in a separate reg.

                    // Let's create a reg to remember the last walking direction
                    // (0 for left, 1 for right).

                    // For next_state logic here, since we need last direction,
                    // must handle in sequential block with the last_dir reg.

                    // So here, next_state depends on last_dir, which needs to be stored.

                    // To avoid combinational loop, in next_state logic treat FALLING as no change,
                    // and update next_state in sequential block based on last_dir when ground=1.

                    next_state = FALLING;
                end else begin
                    next_state = FALLING;
                end
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // To store last walking direction for resuming after falling
    reg last_dir; // 0=left, 1=right

    // Sequential logic: state and last_dir update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state    <= WALK_LEFT;
            last_dir <= 1'b0; // left
        end else begin
            case (state)
                WALK_LEFT: begin
                    if (ground == 1'b0) begin
                        state <= FALLING;
                        last_dir <= 1'b0; // walking left before falling
                    end else if (bump_left || bump_right) begin
                        state <= WALK_RIGHT;
                        last_dir <= 1'b1;
                    end else begin
                        state <= WALK_LEFT;
                        last_dir <= 1'b0;
                    end
                end

                WALK_RIGHT: begin
                    if (ground == 1'b0) begin
                        state <= FALLING;
                        last_dir <= 1'b1; // walking right before falling
                    end else if (bump_left || bump_right) begin
                        state <= WALK_LEFT;
                        last_dir <= 1'b0;
                    end else begin
                        state <= WALK_RIGHT;
                        last_dir <= 1'b1;
                    end
                end

                FALLING: begin
                    if (ground == 1'b1) begin
                        // Land and resume walking in stored direction
                        if (last_dir == 1'b0) begin
                            state <= WALK_LEFT;
                        end else begin
                            state <= WALK_RIGHT;
                        end
                        // last_dir remains unchanged here, since walking direction known
                    end else begin
                        state <= FALLING;
                    end
                end

                default: begin
                    state <= WALK_LEFT;
                    last_dir <= 1'b0;
                end
            endcase
        end
    end

    // Outputs: Moore outputs depend only on current state
    always @(*) begin
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;

        case (state)
            WALK_LEFT:  walk_left  = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALLING:    aaah       = 1'b1;
            default: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
            end
        endcase
    end

endmodule