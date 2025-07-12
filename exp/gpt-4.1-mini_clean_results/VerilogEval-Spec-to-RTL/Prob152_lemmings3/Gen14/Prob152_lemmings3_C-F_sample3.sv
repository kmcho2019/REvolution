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

    // Mode encoding (2 bits)
    localparam MODE_WALK = 2'b00;
    localparam MODE_FALL = 2'b01;

    reg [2:0] state;       // {mode[1:0], direction}
    reg digging_reg;

    wire [1:0] mode = state[2:1];
    wire direction = state[0];

    // Next state and next digging calculation
    reg [2:0] next_state;
    reg next_digging;

    // Combined bump signal for direction switching
    wire bump_any = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    always @(*) begin
        // Default next state and digging remain unchanged
        next_state = state;
        next_digging = digging_reg;

        // Priority: fall > dig > bump direction switch (when walking and not digging)

        if (!ground) begin
            // Fall takes priority over everything; digging stops
            next_state = {MODE_FALL, direction};
            next_digging = 1'b0;
        end else if (mode == MODE_FALL) begin
            // Ground regained while falling: resume walking in same direction
            next_state = {MODE_WALK, direction};
            next_digging = 1'b0;
        end else if (digging_reg) begin
            // Currently digging and on ground
            // Continue digging unless ground lost (handled above)
            next_state = {MODE_WALK, direction};
            next_digging = 1'b1;
        end else begin
            // Currently walking and not digging, on ground
            if (dig) begin
                // Start digging
                next_state = {MODE_WALK, direction};
                next_digging = 1'b1;
            end else if (bump_any) begin
                // Change direction based on bumps
                if (bump_both) begin
                    // Toggle direction if bumped on both sides
                    next_state = {MODE_WALK, ~direction};
                end else if (bump_left) begin
                    next_state = {MODE_WALK, 1'b1}; // walk right
                end else /* bump_right */ begin
                    next_state = {MODE_WALK, 1'b0}; // walk left
                end
                next_digging = 1'b0;
            end
            // else remain walking same direction and not digging
        end
    end

    // Synchronous state and digging updates with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= {MODE_WALK, 1'b0}; // Walk left
            digging_reg <= 1'b0;
        end else begin
            // Update state and digging only if changed to reduce toggling
            if (state !== next_state)
                state <= next_state;
            if (digging_reg !== next_digging)
                digging_reg <= next_digging;
        end
    end

    // Moore outputs
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0) && !digging_reg;
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1) && !digging_reg;
    assign aaah       = (mode == MODE_FALL);
    assign digging    = digging_reg;

endmodule