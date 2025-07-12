module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // One-hot state encoding
    localparam WALK_LEFT  = 3'b001;
    localparam WALK_RIGHT = 3'b010;
    localparam FALL       = 3'b100;

    reg [2:0] state, next_state;
    reg direction, next_direction; // 0 = left, 1 = right

    // Next state logic
    always @(*) begin
        next_state = state;
        next_direction = direction;

        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALL;
                end else begin
                    // bumps cause direction switch
                    if (bump_left || bump_right) begin
                        // flip direction if bumped
                        next_direction = 1'b1; // right
                        next_state = WALK_RIGHT;
                    end
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL;
                end else begin
                    if (bump_left || bump_right) begin
                        next_direction = 1'b0; // left
                        next_state = WALK_LEFT;
                    end
                end
            end

            FALL: begin
                if (ground) begin
                    // ground returned, resume walking in prior direction
                    next_state = (direction == 1'b0) ? WALK_LEFT : WALK_RIGHT;
                    // direction stays the same
                end
                // else remain falling, direction preserved
            end

            default: begin
                // Safety fallback
                next_state = WALK_LEFT;
                next_direction = 1'b0;
            end
        endcase
    end

    // State and direction update (async reset)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            direction <= 1'b0; // left
        end else begin
            state <= next_state;
            direction <= next_direction;
        end
    end

    // Outputs as Moore outputs
    assign aaah       = (state == FALL);
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule