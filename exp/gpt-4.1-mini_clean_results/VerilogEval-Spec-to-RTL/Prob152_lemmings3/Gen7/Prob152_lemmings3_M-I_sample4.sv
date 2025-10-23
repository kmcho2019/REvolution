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

// Mode encoding
localparam MODE_WALK = 2'd0;
localparam MODE_FALL = 2'd1;
localparam MODE_DIG  = 2'd2;

reg dir;    // 0=left, 1=right
reg [1:0] mode;

reg [1:0] next_mode;
reg next_dir;

always @(*) begin
    // Default next state is current state
    next_mode = mode;
    next_dir  = dir;

    case (mode)
        MODE_WALK: begin
            // Priority: falling > digging > bump direction change
            if (!ground) begin
                // Start falling, keep direction
                next_mode = MODE_FALL;
            end else if (dig) begin
                // Start digging if on ground and walking
                next_mode = MODE_DIG;
            end else begin
                // Check bump conditions to change direction
                if (bump_left && bump_right) begin
                    next_dir = ~dir;
                end else if (bump_left) begin
                    next_dir = 1'b1; // walk right
                end else if (bump_right) begin
                    next_dir = 1'b0; // walk left
                end
                next_mode = MODE_WALK;
            end
        end
        MODE_FALL: begin
            // When ground returns, resume walking same direction
            if (ground) begin
                next_mode = MODE_WALK;
            end else begin
                next_mode = MODE_FALL;
            end
            // Direction unchanged during fall
            next_dir = dir;
        end
        MODE_DIG: begin
            // If ground lost while digging, start falling
            if (!ground) begin
                next_mode = MODE_FALL;
            end else begin
                next_mode = MODE_DIG;
            end
            // Direction unchanged during digging
            next_dir = dir;
        end
        default: begin
            // Failsafe: walk left
            next_mode = MODE_WALK;
            next_dir = 1'b0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Async reset to walk left
        dir <= 1'b0;
        mode <= MODE_WALK;
    end else begin
        // Update mode and dir only if different to reduce toggling
        if (mode != next_mode) begin
            mode <= next_mode;
        end
        if (dir != next_dir) begin
            dir <= next_dir;
        end
    end
end

// Output logic - Moore machine outputs depend only on current mode and direction
assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule