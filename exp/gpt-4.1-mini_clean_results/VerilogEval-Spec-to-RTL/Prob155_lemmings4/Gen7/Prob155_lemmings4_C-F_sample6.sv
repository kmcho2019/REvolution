module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Mode/state encoding: 2 bits
    localparam MODE_WALK  = 2'd0;
    localparam MODE_DIG   = 2'd1;
    localparam MODE_FALL  = 2'd2;
    localparam MODE_SPLAT = 2'd3;

    reg [1:0] mode, next_mode;
    reg direction, next_direction;   // 0 = left, 1 = right
    reg [4:0] fall_timer, next_fall_timer;  // fall duration counter saturates at 31

    // Asynchronous reset and sequential registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode       <= MODE_WALK;
            direction  <= 1'b0;   // walk left initially
            fall_timer <= 5'd0;
        end else begin
            mode       <= next_mode;
            direction  <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Combinational next state logic with priority fall > dig > bump
    always @(*) begin
        // Defaults: hold current
        next_mode       = mode;
        next_direction  = direction;
        next_fall_timer = fall_timer;

        case (mode)
            MODE_SPLAT: begin
                // Remain splatted forever; outputs zero
                next_mode       = MODE_SPLAT;
                next_direction  = direction;  // direction irrelevant here
                next_fall_timer = 5'd0;
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed: splat if fall > 20, else resume walking same dir
                    if (fall_timer > 5'd20) begin
                        next_mode       = MODE_SPLAT;
                        next_fall_timer = 5'd0;
                    end else begin
                        next_mode       = MODE_WALK;
                        next_fall_timer = 5'd0;
                    end
                    next_direction = direction;
                end else begin
                    // Continue falling, increment fall timer saturating at 31
                    next_mode = MODE_FALL;
                    if (fall_timer < 5'd31)
                        next_fall_timer = fall_timer + 5'd1;
                    else
                        next_fall_timer = fall_timer;
                    next_direction = direction;
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    // Ground lost: start falling with timer = 1
                    next_mode       = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_direction  = direction;
                end else if (dig) begin
                    // Dig requested on ground: enter dig mode
                    next_mode       = MODE_DIG;
                    next_fall_timer = 5'd0;
                    next_direction  = direction;
                end else if (bump_left || bump_right) begin
                    // Handle bump direction switching
                    // Both bumps => toggle direction
                    if (bump_left && bump_right)
                        next_direction = ~direction;
                    else if (bump_left)
                        next_direction = 1'b1;  // walk right
                    else // bump_right only
                        next_direction = 1'b0;  // walk left

                    next_mode       = MODE_WALK;
                    next_fall_timer = 5'd0;
                end else begin
                    // Continue walking same dir
                    next_mode       = MODE_WALK;
                    next_direction  = direction;
                    next_fall_timer = 5'd0;
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Ground disappeared during dig: start falling with timer=1
                    next_mode       = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_direction  = direction;
                end else begin
                    // Continue digging on ground
                    next_mode       = MODE_DIG;
                    next_fall_timer = 5'd0;
                    next_direction  = direction;
                end
            end

            default: begin
                // Safety fallback: walk left
                next_mode       = MODE_WALK;
                next_direction  = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs: depend only on current state and direction
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule