module TopModule (
    input  clk,
    input  areset,       // async posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State encoding (2 bits)
    localparam WALK  = 2'd0;
    localparam FALL  = 2'd1;
    localparam DIG   = 2'd2;
    localparam SPLAT = 2'd3;

    reg [1:0] state, next_state;

    // Direction bit: 0=left, 1=right
    reg dir, next_dir;

    // Fall timer: counts how long falling; saturates at 31
    reg [4:0] fall_timer, next_fall_timer;

    // Async posedge reset and sequential update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 1'b0;        // start walking left
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            dir <= next_dir;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state and logic
    always @(*) begin
        // Default assignments to hold current values
        next_state = state;
        next_dir = dir;
        next_fall_timer = fall_timer;

        case (state)
            WALK: begin
                // Priority: fall > dig > bump
                if (!ground) begin
                    // Start falling: fall_timer = 1
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_dir = dir;  // keep direction during fall
                end else if (dig) begin
                    // Start digging on ground
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    next_dir = dir;
                end else begin
                    // Handle bump:
                    // bump_left=1 & bump_right=0 => walk right (dir=1)
                    // bump_right=1 & bump_left=0 => walk left (dir=0)
                    // bump_left=1 & bump_right=1 => toggle direction
                    if (bump_left && bump_right) begin
                        next_dir = ~dir;
                    end else if (bump_left) begin
                        next_dir = 1'b1; // right
                    end else if (bump_right) begin
                        next_dir = 1'b0; // left
                    end else begin
                        next_dir = dir;
                    end
                    next_state = WALK;
                    next_fall_timer = 5'd0; // reset fall timer
                end
            end

            FALL: begin
                if (!ground) begin
                    // Continue falling, increment timer saturating at 31
                    next_state = FALL;
                    next_dir = dir;
                    if (fall_timer < 5'd31)
                        next_fall_timer = fall_timer + 5'd1;
                    else
                        next_fall_timer = fall_timer;
                end else begin
                    // Landed: splatter if fell too long
                    if (fall_timer > 5'd20) begin
                        next_state = SPLAT;
                        next_fall_timer = 5'd0;
                        next_dir = dir; // direction irrelevant
                    end else begin
                        next_state = WALK;
                        next_fall_timer = 5'd0;
                        next_dir = dir;
                    end
                end
            end

            DIG: begin
                if (!ground) begin
                    // Fall when ground disappears
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_dir = dir;
                end else begin
                    // Continue digging on ground
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    next_dir = dir;
                end
            end

            SPLAT: begin
                // Remain splatted forever
                next_state = SPLAT;
                next_fall_timer = 5'd0;
                next_dir = dir;
            end

            default: begin
                // Safety fallback
                next_state = WALK;
                next_dir = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs combinational
    always @(*) begin
        // Default outputs
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case (state)
            WALK: begin
                if (dir == 1'b0)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
            end

            FALL: begin
                aaah = 1'b1;
            end

            DIG: begin
                digging = 1'b1;
            end

            SPLAT: begin
                // All outputs remain zero
            end

            default: begin
                // No outputs
            end
        endcase
    end

endmodule