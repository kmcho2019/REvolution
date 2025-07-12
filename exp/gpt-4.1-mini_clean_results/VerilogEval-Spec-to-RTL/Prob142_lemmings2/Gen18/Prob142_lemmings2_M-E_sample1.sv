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
    localparam WALK_LEFT_S  = 3'b001;
    localparam WALK_RIGHT_S = 3'b010;
    localparam FALLING_S    = 3'b100;

    reg [2:0] state, next_state;
    reg       direction, next_direction; // 0 = left, 1 = right

    wire bump_both = bump_left & bump_right;
    wire bump_any  = bump_left | bump_right;

    // Next-state and direction logic
    always @(*) begin
        next_state     = state;
        next_direction = direction;

        case (state)
            WALK_LEFT_S: begin
                if (!ground) begin
                    next_state = FALLING_S; // start falling, keep direction
                end else begin
                    // When grounded and walking left
                    if (bump_both)
                        next_direction = 1'b1; // both bumps -> flip direction to right
                    else if (bump_left)
                        next_direction = 1'b1; // bump left -> walk right
                    else if (bump_right)
                        next_direction = 1'b0; // bump right -> walk left (already walking left, stays)
                    // else direction unchanged

                    // Update walking state if direction changed
                    if (next_direction != 0)
                        next_state = WALK_RIGHT_S;
                    else
                        next_state = WALK_LEFT_S;
                end
            end

            WALK_RIGHT_S: begin
                if (!ground) begin
                    next_state = FALLING_S;
                end else begin
                    if (bump_both)
                        next_direction = 1'b0; // both bumps flip direction to left
                    else if (bump_left)
                        next_direction = 1'b1; // bump left -> walk right (already right, stays)
                    else if (bump_right)
                        next_direction = 1'b0; // bump right -> walk left

                    if (next_direction != 1)
                        next_state = WALK_LEFT_S;
                    else
                        next_state = WALK_RIGHT_S;
                end
            end

            FALLING_S: begin
                if (ground) begin
                    // resume walking according to direction
                    if (direction == 1'b0)
                        next_state = WALK_LEFT_S;
                    else
                        next_state = WALK_RIGHT_S;
                end else begin
                    next_state = FALLING_S; // stay falling, direction unchanged
                end
                // bumps ignored while falling, direction unchanged
            end

            default: begin
                next_state = WALK_LEFT_S;
                next_direction = 1'b0;
            end
        endcase
    end

    // Sequential registers with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state     <= WALK_LEFT_S;
            direction <= 1'b0; // left
        end else begin
            state     <= next_state;
            direction <= next_direction;
        end
    end

    // Moore outputs
    assign aaah       = (state == FALLING_S);
    assign walk_left  = (state == WALK_LEFT_S);
    assign walk_right = (state == WALK_RIGHT_S);

endmodule