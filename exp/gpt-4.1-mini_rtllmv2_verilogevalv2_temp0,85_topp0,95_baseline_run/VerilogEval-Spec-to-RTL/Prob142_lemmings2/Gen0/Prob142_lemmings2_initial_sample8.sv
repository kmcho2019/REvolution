module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // State encoding
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALLING    = 2'b10;

    reg [1:0] state, next_state;
    reg       prev_dir; // 0 for left, 1 for right - stores walking direction before falling

    // Async reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state    <= WALK_LEFT;
            prev_dir <= 1'b0; // left
        end else begin
            state <= next_state;
            // Update prev_dir only when entering FALLING or resuming walking
            if (state != FALLING && next_state == FALLING) begin
                // Store current walking direction before falling
                prev_dir <= (state == WALK_RIGHT) ? 1'b1 : 1'b0;
            end else if (state == FALLING && next_state != FALLING) begin
                // resuming walking, prev_dir remains
                // no change needed here
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // bumped, switch direction to walk right
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // bumped, switch direction to walk left
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground) begin
                    // Resume walking in previous direction
                    next_state = (prev_dir == 1'b0) ? WALK_LEFT : WALK_RIGHT;
                end else begin
                    next_state = FALLING;
                end
            end
            default: begin
                next_state = WALK_LEFT;
            end
        endcase
    end

    // Output logic (Moore outputs)
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);

endmodule