module TopModule (
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

// Define mode states
localparam MODE_WALK  = 2'd0;
localparam MODE_FALL  = 2'd1;
localparam MODE_DIG   = 2'd2;
localparam MODE_SPLAT = 2'd3;

// Direction encoding
// dir=0 => left, dir=1 => right

reg [1:0] mode, next_mode;
reg       dir, next_dir;

reg [4:0] fall_counter, next_fall_counter;

// Combinational next state logic
always @* begin
    // Default assignments: stay in current state/dir/counter
    next_mode = mode;
    next_dir = dir;
    next_fall_counter = fall_counter;

    case (mode)
        MODE_WALK: begin
            if (!ground) begin
                // Ground lost: start falling, reset fall counter
                next_mode = MODE_FALL;
                next_fall_counter = 5'd1; // count first cycle of fall now
                next_dir = dir;
            end else if (dig) begin
                // Start digging only if on ground and walking
                next_mode = MODE_DIG;
                next_fall_counter = 5'd0;
                next_dir = dir;
            end else begin
                // Handle bumps with correct direction logic
                if (bump_left && bump_right) begin
                    // Both sides bumped: toggle direction
                    next_dir = ~dir;
                end else if (bump_left) begin
                    // Bumped left: walk right
                    next_dir = 1'b1;
                end else if (bump_right) begin
                    // Bumped right: walk left
                    next_dir = 1'b0;
                end else begin
                    // No bump: keep direction
                    next_dir = dir;
                end
                next_mode = MODE_WALK;
                next_fall_counter = 5'd0;
            end
        end

        MODE_FALL: begin
            if (ground) begin
                // Landed: check splatter condition using fall_counter
                if (fall_counter > 5'd20) begin
                    next_mode = MODE_SPLAT;
                    next_fall_counter = 5'd0;
                    next_dir = dir;
                end else begin
                    // Recover to walking
                    next_mode = MODE_WALK;
                    next_fall_counter = 5'd0;
                    next_dir = dir;
                end
            end else begin
                // Still falling: increment fall_counter (saturate at 31)
                next_mode = MODE_FALL;
                next_dir = dir;
                if (fall_counter < 5'd31)
                    next_fall_counter = fall_counter + 5'd1;
                else
                    next_fall_counter = fall_counter;
            end
        end

        MODE_DIG: begin
            if (!ground) begin
                // Ground lost while digging -> start falling
                next_mode = MODE_FALL;
                next_fall_counter = 5'd1; // first cycle of falling
                next_dir = dir;
            end else begin
                // Continue digging; ignore bumps and dig inputs
                next_mode = MODE_DIG;
                next_dir = dir;
                next_fall_counter = 5'd0;
            end
        end

        MODE_SPLAT: begin
            // Terminal state, no changes
            next_mode = MODE_SPLAT;
            next_dir = dir;
            next_fall_counter = 5'd0;
        end

        default: begin
            // Safety fallback
            next_mode = MODE_WALK;
            next_dir = 1'b0; // walk left initially
            next_fall_counter = 5'd0;
        end
    endcase
end

// Sequential state and counter update with asynchronous posedge reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= MODE_WALK;
        dir <= 1'b0; // walk left initially
        fall_counter <= 5'd0;
    end else begin
        mode <= next_mode;
        dir <= next_dir;
        fall_counter <= next_fall_counter;
    end
end

// Moore outputs based on current mode and direction
assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule