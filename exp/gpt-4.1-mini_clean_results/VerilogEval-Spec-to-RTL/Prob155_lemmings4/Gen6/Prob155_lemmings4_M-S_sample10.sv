module TopModule (
    input clk,
    input areset,       // asynchronous posedge reset
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State encoding (2 bits)
    localparam [1:0]
        ST_WALK  = 2'b00,
        ST_FALL  = 2'b01,
        ST_DIG   = 2'b10,
        ST_SPLAT = 2'b11;

    reg [1:0] state, next_state;
    reg dir, next_dir;         // 0 = left, 1 = right
    reg [4:0] fall_count, next_fall_count; // counts fall duration, saturates

    // Asynchronous reset, synchronous update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= ST_WALK;
            dir <= 1'b0;       // start walking left
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            dir <= next_dir;
            fall_count <= next_fall_count;
        end
    end

    // Next state and counters logic
    always @(*) begin
        // Defaults: hold current values
        next_state = state;
        next_dir = dir;
        next_fall_count = fall_count;

        case (state)
            ST_WALK: begin
                if (!ground) begin
                    // Start falling
                    next_state = ST_FALL;
                    // fall_count starts at 1
                    next_fall_count = 5'd1;
                end else if (dig) begin
                    // Start digging
                    next_state = ST_DIG;
                    next_fall_count = 5'd0;
                end else begin
                    // Handle bump only when walking on ground
                    if (bump_left && bump_right) begin
                        // reverse direction
                        next_dir = ~dir;
                    end else if (bump_left) begin
                        next_dir = 1'b1; // walk right
                    end else if (bump_right) begin
                        next_dir = 1'b0; // walk left
                    end
                    next_fall_count = 5'd0; // no fall count while walking
                end
            end

            ST_FALL: begin
                if (!ground) begin
                    // continue falling, saturate at max 31
                    next_state = ST_FALL;
                    next_fall_count = (fall_count < 5'd31) ? fall_count + 1'b1 : fall_count;
                    // direction unchanged during fall
                    next_dir = dir;
                end else begin
                    // Landed
                    if (fall_count > 5'd20) begin
                        // splat
                        next_state = ST_SPLAT;
                        next_fall_count = 5'd0;
                    end else begin
                        // resume walking same direction
                        next_state = ST_WALK;
                        next_fall_count = 5'd0;
                    end
                    next_dir = dir;
                end
            end

            ST_DIG: begin
                if (!ground) begin
                    // start falling from dig
                    next_state = ST_FALL;
                    next_fall_count = 5'd1;
                    next_dir = dir;
                end else begin
                    // continue digging
                    next_state = ST_DIG;
                    next_fall_count = 5'd0;
                    next_dir = dir;
                end
            end

            ST_SPLAT: begin
                // remain splatted forever
                next_state = ST_SPLAT;
                next_dir = dir;
                next_fall_count = 5'd0;
            end

            default: begin
                // safety fallback to walking left
                next_state = ST_WALK;
                next_dir = 1'b0;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Moore outputs derived from state and direction
    always @(*) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case (state)
            ST_WALK: begin
                if (dir == 1'b0)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
            end
            ST_FALL: begin
                aaah = 1'b1;
            end
            ST_DIG: begin
                digging = 1'b1;
            end
            ST_SPLAT: begin
                // all outputs zero
            end
            default: begin
                // all outputs zero
            end
        endcase
    end

endmodule