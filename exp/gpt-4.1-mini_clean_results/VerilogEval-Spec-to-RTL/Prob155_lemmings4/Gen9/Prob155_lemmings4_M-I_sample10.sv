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
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer; // fall duration counter

    // Encode bump signals into 2-bit code: 
    // 00 = no bump, 01 = bump_left only, 10 = bump_right only, 11 = both bumps
    wire [1:0] bump_code = {bump_right, bump_left};

    // Asynchronous reset, clocked sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0;  // start walking left
            fall_timer <= 5'd0;
        end else begin
            mode <= next_mode;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next-state logic with priority: fall > dig > bump in walk mode
    always @(*) begin
        // Default assignments
        next_mode = mode;
        next_direction = direction;
        next_fall_timer = 5'd0;

        case (mode)
            MODE_SPLAT: begin
                // Stays splatted forever
                next_mode = MODE_SPLAT;
                next_direction = direction;
                next_fall_timer = 5'd0;
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed: splat if fallen > 20, else walk same dir
                    if (fall_timer > 5'd20) begin
                        next_mode = MODE_SPLAT;
                    end else begin
                        next_mode = MODE_WALK;
                    end
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else begin
                    // Continue falling with gated increment and saturation at 31
                    next_mode = MODE_FALL;
                    next_direction = direction;
                    next_fall_timer = (fall_timer < 5'd31) ? (fall_timer + 5'd1) : fall_timer;
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    // Start falling
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else if (dig) begin
                    // Start digging on ground
                    next_mode = MODE_DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else if (bump_code != 2'b00) begin
                    // Bump changes direction:
                    // both bumps toggle direction
                    // bump_left only -> walk right
                    // bump_right only -> walk left
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    case (bump_code)
                        2'b11: next_direction = ~direction;
                        2'b01: next_direction = 1'b1;  // walk right
                        2'b10: next_direction = 1'b0;  // walk left
                        default: next_direction = direction; // shouldn't happen
                    endcase
                end else begin
                    // Continue walking same direction
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Ground lost during digging, start falling
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else begin
                    // Continue digging on ground
                    next_mode = MODE_DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end

            default: begin
                // Safety fallback to walking left
                next_mode = MODE_WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs derived only from current state and direction
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule