module TopModule (
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

localparam MODE_WALK  = 2'd0;
localparam MODE_DIG   = 2'd1;
localparam MODE_FALL  = 2'd2;
localparam MODE_SPLAT = 2'd3;

reg [2:0] state, next_state; // [2:1] mode, [0] direction
reg [4:0] fall_timer, next_fall_timer;

// Extract mode and direction from state
wire [1:0] mode = state[2:1];
wire direction = state[0];

// Update registers
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= {MODE_WALK, 1'b0}; // walk left
        fall_timer <= 5'd0;
    end else begin
        state <= next_state;
        fall_timer <= next_fall_timer;
    end
end

// Next state logic
always_comb begin
    next_state = state;
    next_fall_timer = fall_timer;

    case (mode)
        MODE_SPLAT: begin
            // Stay splatted forever
            next_state = state;
            next_fall_timer = 5'd0;
        end

        MODE_FALL: begin
            if (ground) begin
                if (fall_timer > 5'd20) begin
                    next_state = {MODE_SPLAT, direction};
                    next_fall_timer = 5'd0;
                end else begin
                    next_state = {MODE_WALK, direction};
                    next_fall_timer = 5'd0;
                end
            end else begin
                // Keep falling, increment timer capped at 21
                next_state = state;
                next_fall_timer = (fall_timer < 5'd21) ? fall_timer + 5'd1 : fall_timer;
            end
        end

        MODE_WALK: begin
            if (!ground) begin
                // Start falling
                next_state = {MODE_FALL, direction};
                next_fall_timer = 5'd1;
            end else if (dig) begin
                // Start digging
                next_state = {MODE_DIG, direction};
                next_fall_timer = 5'd0;
            end else begin
                // Handle bumps (switch directions)
                next_state = state;
                next_fall_timer = 5'd0;
                if (bump_left && bump_right)
                    next_state[0] = ~direction; // toggle direction
                else if (bump_left)
                    next_state[0] = 1'b1;       // walk right
                else if (bump_right)
                    next_state[0] = 1'b0;       // walk left
            end
        end

        MODE_DIG: begin
            if (!ground) begin
                // Fall when ground disappears during digging
                next_state = {MODE_FALL, direction};
                next_fall_timer = 5'd1;
            end else begin
                // Continue digging
                next_state = state;
                next_fall_timer = 5'd0;
            end
        end

        default: begin
            // Default to walking left
            next_state = {MODE_WALK, 1'b0};
            next_fall_timer = 5'd0;
        end
    endcase
end

assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule