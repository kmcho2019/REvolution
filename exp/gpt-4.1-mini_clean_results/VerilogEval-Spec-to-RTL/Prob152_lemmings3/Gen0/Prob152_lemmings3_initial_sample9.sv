module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    input  wire dig,
    output wire walk_left,
    output wire walk_right,
    output wire aaah,
    output wire digging
);

    // State encoding
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL       = 2'b10;

    reg [1:0] state, next_state;
    reg digging_reg, next_digging;
    reg [1:0] prev_walk_state, next_prev_walk_state;

    // State and digging sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            digging_reg <= 1'b0;
            prev_walk_state <= WALK_LEFT;
        end else begin
            state <= next_state;
            digging_reg <= next_digging;
            prev_walk_state <= next_prev_walk_state;
        end
    end

    // Next state logic
    always @* begin
        // Default next state and digging stays the same
        next_state = state;
        next_digging = digging_reg;
        next_prev_walk_state = prev_walk_state;

        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    // Start falling
                    next_state = FALL;
                    next_prev_walk_state = WALK_LEFT;
                    next_digging = 1'b0; // stop digging if any
                end else begin
                    // On ground and walking left
                    if (dig && !digging_reg) begin
                        // Start digging
                        next_digging = 1'b1;
                    end else if (digging_reg) begin
                        // If digging and ground lost, fall
                        if (!ground) begin
                            next_state = FALL;
                            next_prev_walk_state = WALK_LEFT;
                            next_digging = 1'b0;
                        end else if (!ground) begin
                            // Redundant, but safe
                            next_state = FALL;
                            next_prev_walk_state = WALK_LEFT;
                            next_digging = 1'b0;
                        end
                        // else remain digging and walking left
                    end else begin
                        // Not digging, possibly switch direction if bumped
                        if (bump_left || bump_right) begin
                            // switch to walk right
                            next_state = WALK_RIGHT;
                        end
                        // else remain walking left
                    end
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    // Start falling
                    next_state = FALL;
                    next_prev_walk_state = WALK_RIGHT;
                    next_digging = 1'b0; // stop digging if any
                end else begin
                    // On ground and walking right
                    if (dig && !digging_reg) begin
                        // Start digging
                        next_digging = 1'b1;
                    end else if (digging_reg) begin
                        // If digging and ground lost, fall
                        if (!ground) begin
                            next_state = FALL;
                            next_prev_walk_state = WALK_RIGHT;
                            next_digging = 1'b0;
                        end
                        // else remain digging
                    end else begin
                        // Not digging, possibly switch direction if bumped
                        if (bump_left || bump_right) begin
                            // switch to walk left
                            next_state = WALK_LEFT;
                        end
                        // else remain walking right
                    end
                end
            end

            FALL: begin
                // When falling, ignore bumps and dig input
                next_digging = 1'b0;
                if (ground) begin
                    // Ground returned, resume walking previous direction
                    next_state = prev_walk_state;
                    next_prev_walk_state = prev_walk_state;
                    // digging remains 0
                end
            end

            default: begin
                // Should not happen, go to walk left safe state
                next_state = WALK_LEFT;
                next_digging = 1'b0;
                next_prev_walk_state = WALK_LEFT;
            end
        endcase
    end

    // Outputs: Moore outputs depend on state and digging flag
    assign walk_left  = (state == WALK_LEFT)  && !digging_reg && (state != FALL);
    assign walk_right = (state == WALK_RIGHT) && !digging_reg && (state != FALL);
    assign aaah       = (state == FALL);
    assign digging    = digging_reg;

endmodule