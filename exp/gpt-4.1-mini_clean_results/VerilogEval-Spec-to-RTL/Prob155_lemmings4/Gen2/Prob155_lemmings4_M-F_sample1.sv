module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // Mode encoding
    localparam MODE_WALK    = 2'b00;
    localparam MODE_FALL    = 2'b01;
    localparam MODE_DIG     = 2'b10;
    localparam MODE_SPLAT   = 2'b11;

    // Registers for mode and direction
    reg [1:0] mode, next_mode;
    reg       dir, next_dir;      // 0=left, 1=right

    // Fall counter (6 bits to count >20)
    reg [5:0] fall_count, next_fall_count;
    localparam FALL_MAX = 6'd21; // Saturate at 21 to reduce toggling

    // Combinational logic for mode and fall_count next state
    always @(*) begin
        // Defaults: hold current
        next_mode = mode;
        next_fall_count = fall_count;

        case (mode)
            MODE_WALK: begin
                // Highest precedence: fall if no ground
                if (!ground) begin
                    next_mode = MODE_FALL;
                    next_fall_count = 6'd1;
                end
                else if (dig) begin
                    // start digging only when on ground and walking
                    next_mode = MODE_DIG;
                    // fall_count stays unchanged (should be zero or irrelevant here)
                    next_fall_count = 6'd0;
                end
                else begin
                    // remain walking; fall_count reset just in case
                    next_fall_count = 6'd0;
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Ground disappears while digging -> start falling
                    next_mode = MODE_FALL;
                    next_fall_count = 6'd1;
                end
                else begin
                    // Continue digging
                    next_fall_count = 6'd0;
                end
            end

            MODE_FALL: begin
                if (!ground) begin
                    // Continue falling, increment fall counter with saturation
                    if (fall_count < FALL_MAX)
                        next_fall_count = fall_count + 1'b1;
                    else
                        next_fall_count = fall_count; // saturate
                end
                else begin
                    // Ground returns - check splatter condition
                    if (fall_count > 6'd20)
                        next_mode = MODE_SPLAT;
                    else
                        next_mode = MODE_WALK;
                    next_fall_count = 6'd0; // reset fall counter
                end
            end

            MODE_SPLAT: begin
                // Remain splattered forever
                next_fall_count = 6'd0;
            end

            default: begin
                // Unknown mode - reset to walking left safe state
                next_mode = MODE_WALK;
                next_fall_count = 6'd0;
            end
        endcase
    end

    // Sequential mode and fall_count updates with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            fall_count <= 6'd0;
        end else begin
            mode <= next_mode;
            fall_count <= next_fall_count;
        end
    end

    // Sequential direction update: only toggle direction when walking and bumped
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            dir <= 1'b0; // start walking left
        end else begin
            if (mode == MODE_WALK) begin
                if (bump_left || bump_right)
                    dir <= ~dir;
                else
                    dir <= dir; // hold direction
            end else begin
                dir <= dir; // hold direction in other modes
            end
        end
    end

    // Moore outputs depend only on mode and direction
    always @(*) begin
        // Default outputs zero
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;
        digging    = 1'b0;

        case (mode)
            MODE_WALK: begin
                if (dir == 1'b0)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
            end
            MODE_DIG: begin
                digging = 1'b1;
            end
            MODE_FALL: begin
                aaah = 1'b1;
            end
            MODE_SPLAT: begin
                // all zero
            end
            default: begin
                // all zero
            end
        endcase
    end

endmodule