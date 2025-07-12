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
    logic walking_dir; // 0 = left, 1 = right

    // Sequential state and walking_dir update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state       <= WALK_LEFT;
            walking_dir <= 1'b0; // left
        end else begin
            case (state)
                WALK_LEFT, WALK_RIGHT: begin
                    if (ground == 1'b0) begin
                        // ground gone, start falling, keep direction
                        state <= FALLING;
                    end else begin
                        // ground present and walking: check bumps
                        if (bump_left || bump_right) begin
                            // flip direction
                            walking_dir <= ~walking_dir;
                            state <= (walking_dir == 1'b0) ? WALK_RIGHT : WALK_LEFT;
                        end else begin
                            // continue walking same direction
                            state <= (walking_dir == 1'b0) ? WALK_LEFT : WALK_RIGHT;
                        end
                    end
                end
                FALLING: begin
                    if (ground == 1'b1) begin
                        // landed, resume walking in stored direction
                        state <= (walking_dir == 1'b0) ? WALK_LEFT : WALK_RIGHT;
                    end else begin
                        // still falling
                        state <= FALLING;
                    end
                    // walking_dir remains unchanged in FALLING
                end
                default: begin
                    state <= WALK_LEFT;
                    walking_dir <= 1'b0;
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
            WALK_LEFT:  walk_left = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALLING:    aaah = 1'b1;
            default: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
            end
        endcase
    end

endmodule