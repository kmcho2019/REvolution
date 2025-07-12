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

    // State encoding as enumerated types
    localparam WALK_LEFT  = 2'd0;
    localparam WALK_RIGHT = 2'd1;
    localparam FALL_LEFT  = 2'd2;
    localparam FALL_RIGHT = 2'd3;

    reg [1:0] state, next_state;

    // Next-state logic
    always @(*) begin
        next_state = state;

        case (state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALL_LEFT;
                else if (bump_left || bump_right) begin
                    // Switch direction on bump
                    next_state = WALK_RIGHT;
                end
            end

            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALL_RIGHT;
                else if (bump_left || bump_right) begin
                    // Switch direction on bump
                    next_state = WALK_LEFT;
                end
            end

            FALL_LEFT: begin
                if (ground)
                    next_state = WALK_LEFT;
                else
                    next_state = FALL_LEFT;
                // Bumps while falling do not change direction
            end

            FALL_RIGHT: begin
                if (ground)
                    next_state = WALK_RIGHT;
                else
                    next_state = FALL_RIGHT;
                // Bumps while falling do not change direction
            end

            default: next_state = WALK_LEFT; // safety fallback
        endcase
    end

    // State update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Moore outputs
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule