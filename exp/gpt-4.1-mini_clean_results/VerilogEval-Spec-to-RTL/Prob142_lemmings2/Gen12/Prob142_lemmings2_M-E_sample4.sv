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

    // State encoding (one-hot)
    // Use three flip-flops for states
    localparam WALK_LEFT  = 3'b001;
    localparam WALK_RIGHT = 3'b010;
    localparam FALLING    = 3'b100;

    reg [2:0] state, next_state;
    reg direction; // 0=left, 1=right: stores walking direction during falling

    // Combinational next-state logic
    always @(*) begin
        // Defaults
        next_state = state;

        case (state)
            WALK_LEFT: begin
                if (ground == 1'b0) begin
                    // Ground lost, start falling and remember direction = 0 (left)
                    next_state = FALLING;
                end else begin
                    // On ground walking left
                    // If bump on either side, switch direction accordingly
                    if (bump_left && bump_right) begin
                        next_state = WALK_RIGHT;
                    end else if (bump_left) begin
                        next_state = WALK_RIGHT;
                    end else if (bump_right) begin
                        next_state = WALK_RIGHT;
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end
            end
            WALK_RIGHT: begin
                if (ground == 1'b0) begin
                    // Ground lost, start falling and remember direction = 1 (right)
                    next_state = FALLING;
                end else begin
                    // On ground walking right
                    // If bump on either side, switch direction accordingly
                    if (bump_left && bump_right) begin
                        next_state = WALK_LEFT;
                    end else if (bump_left) begin
                        next_state = WALK_LEFT;
                    end else if (bump_right) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end
            end
            FALLING: begin
                if (ground == 1'b1) begin
                    // Ground returned, resume walking in stored direction
                    if (direction == 1'b0) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end else begin
                    // Keep falling, ignore bumps
                    next_state = FALLING;
                end
            end
            default: begin
                next_state = WALK_LEFT; // Safe default
            end
        endcase
    end

    // Sequential logic: state and direction update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state     <= WALK_LEFT;
            direction <= 1'b0; // left
        end else begin
            state <= next_state;
            // Update direction only when entering FALLING state
            if ((state == WALK_LEFT && next_state == FALLING) ||
                (state == WALK_RIGHT && next_state == FALLING)) begin
                direction <= (state == WALK_LEFT) ? 1'b0 : 1'b1;
            end
            // Otherwise, keep direction unchanged
        end
    end

    // Output assignments from one-hot state encoding
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);

endmodule