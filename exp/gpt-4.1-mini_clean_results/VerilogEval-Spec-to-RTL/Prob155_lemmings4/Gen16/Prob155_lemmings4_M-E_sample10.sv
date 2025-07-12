module TopModule (
    input  clk,
    input  areset,       // asynchronous positive edge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding (3 bits)
    // bit0 = direction (0=left,1=right)
    // bit2-bit1 = mode:
    // 00 = walk
    // 01 = dig
    // 10 = fall
    // 11 = splat
    localparam
        WLK_L = 3'b000,
        WLK_R = 3'b001,
        DIG_L = 3'b010,
        DIG_R = 3'b011,
        FAL_L = 3'b100,
        FAL_R = 3'b101,
        SPLAT = 3'b110; // splat state; direction irrelevant, use fixed

    reg [2:0] state, next_state;
    reg [4:0] fall_timer, next_fall_timer;

    // Asynchronous positive edge reset and synchronous update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WLK_L;       // start walking left
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    // Decode current mode and direction
    wire [1:0] mode = state[2:1];
    wire direction = state[0]; // 0=left,1=right

    // Next state logic with prioritized conditions: fall > dig > bump (only walking)
    always @(*) begin
        next_state = state;
        next_fall_timer = 5'd0;

        case (mode)
            2'b11: begin
                // SPLAT: remain splatted forever
                next_state = SPLAT;
                next_fall_timer = 5'd0;
            end

            2'b10: begin
                // FALL
                if (ground) begin
                    // Landed: splat if fallen > 20 cycles
                    if (fall_timer > 5'd20)
                        next_state = SPLAT;
                    else begin
                        // resume walking in same direction
                        next_state = {2'b00, direction};
                    end
                    next_fall_timer = 5'd0;
                end else begin
                    // Continue falling, increment timer
                    next_state = state;
                    // increment timer, saturate at max 31 to avoid overflow
                    if (fall_timer == 5'd31)
                        next_fall_timer = 5'd31;
                    else
                        next_fall_timer = fall_timer + 5'd1;
                end
            end

            2'b00: begin
                // WALK
                if (!ground) begin
                    // Start falling, retain direction
                    next_state = {2'b10, direction};
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    // Start digging if on ground and walking
                    next_state = {2'b01, direction};
                    next_fall_timer = 5'd0;
                end else if (bump_left || bump_right) begin
                    // Switch direction when bumped (any bump toggles or set dir)
                    if (bump_left && bump_right) begin
                        // Both bumps toggle direction
                        next_state = {2'b00, ~direction};
                    end else if (bump_left) begin
                        // bump left => walk right
                        next_state = WLK_R;
                    end else begin
                        // bump right => walk left
                        next_state = WLK_L;
                    end
                    next_fall_timer = 5'd0;
                end else begin
                    // keep walking same direction
                    next_state = state;
                    next_fall_timer = 5'd0;
                end
            end

            2'b01: begin
                // DIG
                if (!ground) begin
                    // If ground disappears while digging, start falling
                    next_state = {2'b10, direction};
                    next_fall_timer = 5'd1;
                end else begin
                    // Continue digging
                    next_state = state;
                    next_fall_timer = 5'd0;
                    // Ignore bumps and dig input while digging
                end
            end

            default: begin
                // Defensive reset to walk left
                next_state = WLK_L;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs
    assign walk_left  = (mode == 2'b00) && (direction == 1'b0);
    assign walk_right = (mode == 2'b00) && (direction == 1'b1);
    assign aaah       = (mode == 2'b10);
    assign digging    = (mode == 2'b01);

endmodule