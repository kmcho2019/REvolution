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
localparam MODE_WALK    = 2'd0;
localparam MODE_FALL    = 2'd1;
localparam MODE_DIG     = 2'd2;
localparam MODE_SPLAT   = 2'd3;

// Direction encoding
// dir=0 => left, dir=1 => right

reg [1:0] mode, next_mode;
reg       dir, next_dir;

reg [4:0] fall_counter, next_fall_counter;

// Next mode logic
always @* begin
    // Default next values
    next_mode = mode;
    next_dir = dir;
    next_fall_counter = fall_counter;

    case (mode)
        MODE_WALK: begin
            if (!ground) begin
                // Start falling in current direction
                next_mode = MODE_FALL;
                next_fall_counter = 5'd0;
            end else if (dig) begin
                // Start digging in current direction (only if on ground)
                next_mode = MODE_DIG;
                // direction unchanged
                // fall_counter reset
                next_fall_counter = 5'd0;
            end else begin
                // Handle bump signals (falling/digging ignored)
                if (bump_left || bump_right) begin
                    // Switch direction
                    next_dir = ~dir;
                end
                next_mode = MODE_WALK;
                next_fall_counter = 5'd0;
            end
        end

        MODE_FALL: begin
            if (ground) begin
                // Ground regained, check splatter
                if (fall_counter > 5'd20) begin
                    // splatter now
                    next_mode = MODE_SPLAT;
                    next_fall_counter = 5'd0;
                end else begin
                    // back to walking, keep direction
                    next_mode = MODE_WALK;
                    next_fall_counter = 5'd0;
                end
                // direction unchanged
                next_dir = dir;
            end else begin
                // Continue falling
                next_mode = MODE_FALL;
                next_dir = dir;
                // increment counter in sequential block
                next_fall_counter = fall_counter; 
            end
        end

        MODE_DIG: begin
            if (!ground) begin
                // start falling when no ground while digging
                next_mode = MODE_FALL;
                next_fall_counter = 5'd0;
                // direction unchanged
                next_dir = dir;
            end else begin
                // continue digging ignoring bumps and dig input
                next_mode = MODE_DIG;
                next_dir = dir;
                next_fall_counter = 5'd0;
            end
        end

        MODE_SPLAT: begin
            // terminal state
            next_mode = MODE_SPLAT;
            next_dir = dir;
            next_fall_counter = 5'd0;
        end

        default: begin
            // should never happen: default to walk left
            next_mode = MODE_WALK;
            next_dir = 1'b0; // left
            next_fall_counter = 5'd0;
        end
    endcase
end

// Sequential logic for mode, dir, and fall_counter
always @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= MODE_WALK;
        dir <= 1'b0; // left
        fall_counter <= 5'd0;
    end else begin
        mode <= next_mode;
        dir <= next_dir;
        // update fall counter properly
        if (mode == MODE_FALL && !ground) begin
            // increment fall_counter when still falling and no ground
            fall_counter <= fall_counter + 1'b1;
        end else begin
            // reset counter otherwise (including splatter and non-falling modes)
            fall_counter <= 5'd0;
        end
    end
end

// Moore outputs based on current mode and direction
assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule