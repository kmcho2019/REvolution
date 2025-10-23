module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding (2 bits):
    // bit 1: mode (0=walk,1=fall)
    // bit 0: direction (0=left,1=right)
    localparam WALK_LEFT  = 2'b00; // mode=0, dir=0
    localparam WALK_RIGHT = 2'b01; // mode=0, dir=1
    localparam FALL_LEFT  = 2'b10; // mode=1, dir=0
    localparam FALL_RIGHT = 2'b11; // mode=1, dir=1

    reg [1:0] state, next_state;
    reg digging_reg, next_digging;

    wire mode = state[1];
    wire direction = state[0];

    // Combine bump signals for direction change check
    wire bump_any = bump_left | bump_right;

    always @(*) begin
        // Default next values: hold current state and digging
        next_state = state;
        next_digging = digging_reg;

        if (!ground) begin
            // Priority 1: fall if no ground
            // Falling cancels digging
            next_state = {1'b1, direction}; // mode=1 (fall), keep direction
            next_digging = 1'b0;
        end else if (mode == 1'b1) begin
            // Ground returns and was falling: walk same direction, no digging
            next_state = {1'b0, direction}; // mode=0 (walk), keep direction
            next_digging = 1'b0;
        end else if (digging_reg) begin
            // Currently digging on ground
            // Continue digging unless ground lost (handled above)
            next_state = state;
            next_digging = 1'b1;
        end else begin
            // Walking and not digging on ground
            if (dig) begin
                // Start digging
                next_state = state;
                next_digging = 1'b1;
            end else if (bump_any) begin
                // Switch directions on bump
                // If both bump_left and bump_right, flip direction
                if (bump_left && bump_right)
                    next_state = {1'b0, ~direction}; // walk, flipped direction
                else if (bump_left)
                    next_state = {1'b0, 1'b1}; // walk right
                else // bump_right only
                    next_state = {1'b0, 1'b0}; // walk left
                next_digging = 1'b0;
            end else begin
                // Keep walking same direction, no digging
                next_state = state;
                next_digging = 1'b0;
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            digging_reg <= 1'b0;
        end else begin
            state <= next_state;
            digging_reg <= next_digging;
        end
    end

    // Moore outputs
    assign walk_left  = (mode == 1'b0) && (direction == 1'b0) && !digging_reg;
    assign walk_right = (mode == 1'b0) && (direction == 1'b1) && !digging_reg;
    assign aaah       = (mode == 1'b1);
    assign digging    = digging_reg;

endmodule