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

    // State encoding - one-hot style (3 states)
    localparam WALK_LEFT  = 3'b001;
    localparam WALK_RIGHT = 3'b010;
    localparam FALLING    = 3'b100;

    reg [2:0] state, next_state;
    reg direction; // 0=left, 1=right: stores walking direction across falling

    // Determine if bumped on any side
    wire bumped = bump_left | bump_right;

    // Compute next direction based on bump and current direction
    // Only changes if bumped while walking
    wire new_direction = (bumped) ? ~direction : direction;

    // Next-state logic
    always @(*) begin
        // Default hold
        next_state = state;

        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    // Start falling, keep direction
                    next_state = FALLING;
                end else if (bumped) begin
                    // Bumped, flip direction and switch walking state
                    next_state = WALK_RIGHT;
                end else begin
                    // Keep walking left
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bumped) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                // In falling state
                if (ground) begin
                    // Land, resume walking in stored direction
                    next_state = direction ? WALK_RIGHT : WALK_LEFT;
                end else begin
                    // Stay falling
                    next_state = FALLING;
                end
            end
            default: begin
                // Should never occur, reset to WALK_LEFT
                next_state = WALK_LEFT;
            end
        endcase
    end

    // Sequential logic for state and direction with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            direction <= 1'b0; // left
        end else begin
            state <= next_state;

            // Update direction only while walking and bumped
            if (state == WALK_LEFT || state == WALK_RIGHT) begin
                if (bumped) begin
                    direction <= new_direction;
                end
                // else keep direction
            end
            // While falling, direction unchanged
        end
    end

    // Moore outputs
    assign aaah       = (state == FALLING);
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule