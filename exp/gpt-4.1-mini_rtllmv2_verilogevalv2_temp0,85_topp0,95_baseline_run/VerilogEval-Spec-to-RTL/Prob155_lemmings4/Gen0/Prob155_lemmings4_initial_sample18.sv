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
        WALK_LEFT = 3'd0,
        WALK_RIGHT = 3'd1,
        FALLING_LEFT = 3'd2,
        FALLING_RIGHT = 3'd3,
        DIGGING_LEFT = 3'd4,
        DIGGING_RIGHT = 3'd5,
        SPLATTERED = 3'd6
    } state_t;

    state_t state, next_state;

    // 5-bit counter for falling time (max 20)
    reg [4:0] fall_count, next_fall_count;

    // Direction helper
    wire bumped = bump_left | bump_right;

    // Asynchronous posedge reset and state/fall_count update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            fall_count <= next_fall_count;
        end
    end

    // Next state and fall counter logic
    always @(*) begin
        // Default next values
        next_state = state;
        next_fall_count = fall_count;

        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING_LEFT;
                    next_fall_count = 5'd1;
                end else if (dig) begin
                    next_state = DIGGING_LEFT;
                    next_fall_count = 5'd0;
                end else if (bumped) begin
                    // switch directions if bumped left or right or both
                    next_state = WALK_RIGHT;
                    next_fall_count = 5'd0;
                end else begin
                    next_fall_count = 5'd0;
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING_RIGHT;
                    next_fall_count = 5'd1;
                end else if (dig) begin
                    next_state = DIGGING_RIGHT;
                    next_fall_count = 5'd0;
                end else if (bumped) begin
                    next_state = WALK_LEFT;
                    next_fall_count = 5'd0;
                end else begin
                    next_fall_count = 5'd0;
                    next_state = WALK_RIGHT;
                end
            end

            FALLING_LEFT: begin
                // Increment fall count but saturate at max (31)
                if (fall_count < 5'd31)
                    next_fall_count = fall_count + 5'd1;
                else
                    next_fall_count = 5'd31;

                if (ground) begin
                    if (fall_count > 5'd20) begin
                        // splatter if fallen more than 20 cycles and hit ground
                        next_state = SPLATTERED;
                        next_fall_count = 5'd0;
                    end else begin
                        next_state = WALK_LEFT;
                        next_fall_count = 5'd0;
                    end
                end
            end

            FALLING_RIGHT: begin
                if (fall_count < 5'd31)
                    next_fall_count = fall_count + 5'd1;
                else
                    next_fall_count = 5'd31;

                if (ground) begin
                    if (fall_count > 5'd20) begin
                        next_state = SPLATTERED;
                        next_fall_count = 5'd0;
                    end else begin
                        next_state = WALK_RIGHT;
                        next_fall_count = 5'd0;
                    end
                end
            end

            DIGGING_LEFT: begin
                if (!ground) begin
                    // If ground disappears, fall with same direction
                    next_state = FALLING_LEFT;
                    next_fall_count = 5'd1;
                end else begin
                    next_state = DIGGING_LEFT;
                    next_fall_count = 5'd0;
                end
            end

            DIGGING_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING_RIGHT;
                    next_fall_count = 5'd1;
                end else begin
                    next_state = DIGGING_RIGHT;
                    next_fall_count = 5'd0;
                end
            end

            SPLATTERED: begin
                // Remain splattered forever until reset
                next_state = SPLATTERED;
                next_fall_count = 5'd0;
            end

            default: begin
                next_state = WALK_LEFT;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Moore outputs depend only on current state
    always @(*) begin
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
            FALLING_LEFT: begin
                aaah = 1'b1;
            end
            FALLING_RIGHT: begin
                aaah = 1'b1;
            end
            DIGGING_LEFT: begin
                digging = 1'b1;
            end
            DIGGING_RIGHT: begin
                digging = 1'b1;
            end
            SPLATTERED: begin
                // All outputs zero
            end
        endcase
    end

endmodule