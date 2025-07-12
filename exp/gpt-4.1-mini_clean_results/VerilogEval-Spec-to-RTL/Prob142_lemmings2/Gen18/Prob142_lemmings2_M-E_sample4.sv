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

    // One-hot state encoding for clarity:
    localparam WALK_LEFT  = 3'b001;
    localparam WALK_RIGHT = 3'b010;
    localparam FALL       = 3'b100;

    reg [2:0] state, next_state;
    // Direction register used during falling to remember direction:
    // 0 = left, 1 = right
    reg direction, next_direction;

    // Current walking or falling state signals
    wire walking = (state == WALK_LEFT) || (state == WALK_RIGHT);
    wire falling = (state == FALL);

    // Combinational logic for next state and direction
    always @(*) begin
        // Default assignments: hold current values
        next_state = state;
        next_direction = direction;

        if (walking) begin
            // Walking states: WALK_LEFT or WALK_RIGHT
            if (!ground) begin
                // Ground gone: start falling, save current direction
                next_state = FALL;
                next_direction = (state == WALK_RIGHT) ? 1'b1 : 1'b0;
            end else begin
                // Ground present: handle bumps
                if (bump_left && bump_right) begin
                    // Bumped both sides: flip direction
                    if (state == WALK_LEFT) begin
                        next_state = WALK_RIGHT;
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end else if (bump_left) begin
                    // Bumped on left: walk right
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    // Bumped on right: walk left
                    next_state = WALK_LEFT;
                end else begin
                    // No bump: remain same
                    next_state = state;
                end
                // Direction register stays consistent with state
                next_direction = (next_state == WALK_RIGHT) ? 1'b1 : 1'b0;
            end
        end else if (falling) begin
            // Falling state: ignore bumps
            if (ground) begin
                // Ground reappeared: resume walking in stored direction
                next_state = (direction == 1'b1) ? WALK_RIGHT : WALK_LEFT;
                // direction stays as-is
                next_direction = direction;
            end
            // else remain falling
        end else begin
            // Should not happen, default to WALK_LEFT for safety
            next_state = WALK_LEFT;
            next_direction = 1'b0;
        end
    end

    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            direction <= 1'b0;
        end else begin
            state <= next_state;
            direction <= next_direction;
        end
    end

    // Moore outputs
    assign aaah = (state == FALL);
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule