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

    // State encoding (3 bits for clarity)
    // 0: WALK_LEFT
    // 1: WALK_RIGHT
    // 2: DIG_LEFT
    // 3: DIG_RIGHT
    // 4: FALL_LEFT
    // 5: FALL_RIGHT
    localparam [2:0]
        WALK_LEFT  = 3'd0,
        WALK_RIGHT = 3'd1,
        DIG_LEFT   = 3'd2,
        DIG_RIGHT  = 3'd3,
        FALL_LEFT  = 3'd4,
        FALL_RIGHT = 3'd5;

    reg [2:0] state, next_state;

    // Synchronous state update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Combinational next state logic
    always @* begin
        next_state = state; // default hold

        case (state)
            WALK_LEFT: begin
                // Priority fall > dig > bump
                if (ground == 1'b0) begin
                    next_state = FALL_LEFT;
                end else if (dig) begin
                    next_state = DIG_LEFT;
                end else if (bump_left || bump_right) begin
                    // switch direction on bump
                    next_state = WALK_RIGHT;
                end
            end

            WALK_RIGHT: begin
                if (ground == 1'b0) begin
                    next_state = FALL_RIGHT;
                end else if (dig) begin
                    next_state = DIG_RIGHT;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end
            end

            DIG_LEFT: begin
                if (ground == 1'b0) begin
                    // ground gone -> fall left
                    next_state = FALL_LEFT;
                end
                // dig continues while ground=1, dig input ignored after start
                // bumps ignored
            end

            DIG_RIGHT: begin
                if (ground == 1'b0) begin
                    next_state = FALL_RIGHT;
                end
                // dig continues while ground=1
                // bumps ignored
            end

            FALL_LEFT: begin
                if (ground == 1'b1) begin
                    // landed, walk left
                    next_state = WALK_LEFT;
                end
                // bumps ignored
            end

            FALL_RIGHT: begin
                if (ground == 1'b1) begin
                    next_state = WALK_RIGHT;
                end
                // bumps ignored
            end

            default: begin
                // safety fallback
                next_state = WALK_LEFT;
            end
        endcase
    end

    // Outputs - Moore FSM, outputs depend on state only
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
    assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule