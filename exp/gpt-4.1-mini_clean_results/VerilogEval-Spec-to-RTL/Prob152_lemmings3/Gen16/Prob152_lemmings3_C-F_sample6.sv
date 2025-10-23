module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State bits:
    // bit 1 = direction (0=left, 1=right)
    // bit 0 = mode (0=walk, 1=fall)
    localparam WLK_LEFT  = 2'b00;
    localparam WLK_RIGHT = 2'b10;
    localparam FAL_LEFT  = 2'b01;
    localparam FAL_RIGHT = 2'b11;

    reg [1:0] state, next_state;
    reg digging_reg, next_digging;

    wire direction = state[1];
    wire mode      = state[0]; // 0=walk, 1=fall

    // Compute if bumped (any bump)
    wire bumped = bump_left || bump_right;
    // Compute new direction if bumped: 
    // If both bumps, toggle direction; else if left bump, go right; else if right bump, go left.
    wire dir_bump = (bump_left && bump_right) ? ~direction :
                    (bump_left ? 1'b1 : 1'b0);

    always @(*) begin
        next_state = state;
        next_digging = digging_reg;

        // Priority 1: Fall (ground lost) overrides all modes
        if (!ground) begin
            // Start falling in current direction, digging stops
            next_state = {direction, 1'b1};
            next_digging = 1'b0;
        end else if (mode == 1'b1) begin
            // Was falling, ground restored: walk same direction, digging off
            next_state = {direction, 1'b0};
            next_digging = 1'b0;
        end else if (digging_reg) begin
            // Currently digging, still on ground (because if no ground, it falls already)
            // Continue digging while ground is present
            // If ground lost, next_state and digging handled above
            next_state = state;
            next_digging = 1'b1;
        end else begin
            // Walking on ground and not digging
            // Priority 1: fall handled above
            // Priority 2: start digging if dig=1
            if (dig) begin
                next_state = state; // keep walking state and direction
                next_digging = 1'b1;
            end else if (bumped) begin
                // Switch direction on bump
                next_state = {dir_bump, 1'b0}; // walking mode with updated direction
                next_digging = 1'b0;
            end else begin
                // Keep current walking state and no digging
                next_state = state;
                next_digging = 1'b0;
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WLK_LEFT;
            digging_reg <= 1'b0;
        end else begin
            state <= next_state;
            digging_reg <= next_digging;
        end
    end

    // Outputs
    // Walk left: walking mode, direction=0, not digging
    assign walk_left  = (mode == 1'b0) && (direction == 1'b0) && !digging_reg;
    // Walk right: walking mode, direction=1, not digging
    assign walk_right = (mode == 1'b0) && (direction == 1'b1) && !digging_reg;
    // Falling: mode=fall (1), regardless of digging (which should be 0)
    assign aaah       = (mode == 1'b1);
    // Digging flag
    assign digging    = digging_reg;

endmodule