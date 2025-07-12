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

    // State encoding: 3 bits [direction, mode, digging]
    // direction: 0=left, 1=right (bit 2)
    // mode: 0=walk, 1=fall (bit 1)
    // digging: 0=not digging, 1=digging (bit 0)
    localparam WLK_LEFT_ND  = 3'b000;
    localparam WLK_LEFT_D   = 3'b001;
    localparam FAL_LEFT_ND  = 3'b010;
    localparam FAL_LEFT_D   = 3'b011; // theoretically not used, digging stops on fall but kept for completeness

    localparam WLK_RIGHT_ND = 3'b100;
    localparam WLK_RIGHT_D  = 3'b101;
    localparam FAL_RIGHT_ND = 3'b110;
    localparam FAL_RIGHT_D  = 3'b111; // same as above

    reg [2:0] state, next_state;

    // Extract bits for readability
    wire direction = state[2];
    wire mode      = state[1];
    wire digging_r = state[0];

    always @(*) begin
        // Default: hold current state
        next_state = state;

        // Priority 1: Fall if no ground (falling overrides digging and bump)
        if (!ground) begin
            // Enter falling mode, digging stops
            next_state = {direction, 1'b1, 1'b0};
        end else if (mode == 1'b1) begin
            // Ground is back and we were falling => resume walking, digging off
            next_state = {direction, 1'b0, 1'b0};
        end else if (digging_r) begin
            // Currently digging and ground present
            // If ground lost, fall and stop digging (handled above), else continue digging
            // Here ground is present, so continue digging
            next_state = state;
        end else begin
            // Walking on ground and not digging
            // Check dig command
            if (dig) begin
                // Start digging
                next_state = {direction, 1'b0, 1'b1};
            end else if (bump_left || bump_right) begin
                // Direction change on bump when walking and not digging
                // Flip direction if both bumps or choose opposite direction if single bump
                // Direction bit is bit 2
                if (bump_left && bump_right) begin
                    next_state = {~direction, 1'b0, 1'b0};
                end else if (bump_left) begin
                    next_state = {1'b1, 1'b0, 1'b0}; // walk right
                end else begin
                    // bump_right
                    next_state = {1'b0, 1'b0, 1'b0}; // walk left
                end
            end else begin
                // Keep walking same direction, no dig, no fall
                next_state = {direction, 1'b0, 1'b0};
            end
        end
    end

    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WLK_LEFT_ND;
        end else begin
            state <= next_state;
        end
    end

    // Outputs from state bits (Moore outputs)
    assign walk_left  = (mode == 1'b0) && (direction == 1'b0) && (digging_r == 1'b0);
    assign walk_right = (mode == 1'b0) && (direction == 1'b1) && (digging_r == 1'b0);
    assign aaah       = (mode == 1'b1);
    assign digging    = digging_r;

endmodule