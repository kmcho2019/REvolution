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

    // State encoding: direction (bit 1), mode (bit 0 and extra)
    // direction: 0=left, 1=right
    // mode: 2-bit encoded as:
    //   2'b00 = walking
    //   2'b01 = falling
    //   2'b10 = digging
    //   2'b11 = unused

    // We'll hold mode as 2 bits and direction as 1 bit separately
    reg direction;  // 0 left, 1 right
    reg [1:0] mode; // 00 walk, 01 fall, 10 dig

    // Next state signals
    reg next_direction;
    reg [1:0] next_mode;

    // Mode encoding
    localparam WALKING = 2'b00;
    localparam FALLING = 2'b01;
    localparam DIGGING = 2'b10;

    always @(*) begin
        // Defaults keep current state
        next_direction = direction;
        next_mode = mode;

        // Priority 1: Falling if no ground
        if (!ground) begin
            // Enter falling mode, digging ends
            next_mode = FALLING;
            // Direction preserved while falling
            next_direction = direction;
        end else if (mode == FALLING) begin
            // Ground restored after falling, resume walking
            next_mode = WALKING;
            next_direction = direction;
        end else if (mode == DIGGING) begin
            // Digging continues if ground present
            if (!ground) begin
                // No ground means start falling (handled above)
                // But here ground==1 so continue digging
                // Redundant check but keep for clarity
                next_mode = DIGGING;
            end else begin
                // Continue digging on ground
                next_mode = DIGGING;
            end
            // Direction unchanged while digging
            next_direction = direction;
        end else begin
            // mode == WALKING and ground present
            if (dig) begin
                // Start digging when walking on ground
                next_mode = DIGGING;
                next_direction = direction;
            end else if (bump_left && bump_right) begin
                // Both bumps: switch direction
                next_direction = ~direction;
                next_mode = WALKING;
            end else if (bump_left) begin
                // Bump left -> walk right
                next_direction = 1'b1;
                next_mode = WALKING;
            end else if (bump_right) begin
                // Bump right -> walk left
                next_direction = 1'b0;
                next_mode = WALKING;
            end else begin
                // No bump, keep walking same direction
                next_mode = WALKING;
                next_direction = direction;
            end
        end
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk left
            mode <= WALKING;
        end else begin
            direction <= next_direction;
            mode <= next_mode;
        end
    end

    // Output decoding - Moore outputs
    assign walk_left  = (mode == WALKING) && (direction == 1'b0);
    assign walk_right = (mode == WALKING) && (direction == 1'b1);
    assign aaah       = (mode == FALLING);
    assign digging    = (mode == DIGGING);

endmodule