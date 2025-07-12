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

    // State encoding
    localparam WALK_LEFT  = 2'd0;
    localparam WALK_RIGHT = 2'd1;
    localparam FALL       = 2'd2;

    reg [1:0] state, next_state;
    reg       direction, next_direction;

    // Sequential state and direction registers with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state     <= WALK_LEFT;
            direction <= 1'b0; // 0 = left, 1 = right
        end else begin
            state     <= next_state;
            direction <= next_direction;
        end
    end

    // Combinational next-state and next-direction logic
    always @(*) begin
        // Defaults keep current state and direction
        next_state     = state;
        next_direction = direction;

        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    // Start falling, direction saved
                    next_state = FALL;
                    // direction unchanged
                end else if (bump_left || (bump_left && bump_right)) begin
                    // Bumped on left or both: switch right
                    next_state     = WALK_RIGHT;
                    next_direction = 1'b1;
                end
                // bump_right does not affect direction when walking left
                // hold state otherwise
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL;
                    // direction unchanged
                end else if (bump_right || (bump_left && bump_right)) begin
                    // Bumped on right or both: switch left
                    next_state     = WALK_LEFT;
                    next_direction = 1'b0;
                end
                // bump_left does not affect direction when walking right
                // hold state otherwise
            end

            FALL: begin
                // Falling: ignore bumps
                if (ground) begin
                    // Ground reappears: resume walking in last direction
                    next_state = direction ? WALK_RIGHT : WALK_LEFT;
                    // direction unchanged
                end
                // else remain FALL, direction unchanged
            end

            default: begin
                // Defensive coding: reset to walk left
                next_state     = WALK_LEFT;
                next_direction = 1'b0;
            end
        endcase
    end

    // Moore outputs
    assign aaah       = (state == FALL);
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule