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

localparam [1:0]
    WALK  = 2'd0,
    DIG   = 2'd1,
    FALL  = 2'd2,
    SPLAT = 2'd3;

reg [2:0] state, next_state; 
// [2:1]: mode, [0]: direction (0=left,1=right)
reg [4:0] fall_timer, next_fall_timer;

// Separate mode and direction for clarity
wire [1:0] mode = state[2:1];
wire direction = state[0];

// Async reset and state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Start walking left on reset
        state <= {WALK, 1'b0};
        fall_timer <= 5'd0;
    end else begin
        state <= next_state;
        fall_timer <= next_fall_timer;
    end
end

always @* begin
    next_state = state;
    next_fall_timer = fall_timer;

    case (mode)
        SPLAT: begin
            // Remain splatted forever
            next_state = state; // no change
            next_fall_timer = 5'd0;
        end

        FALL: begin
            if (ground) begin
                // Landed after fall
                if (fall_timer > 20) begin
                    // Splatter
                    next_state = {SPLAT, direction};
                    next_fall_timer = 5'd0;
                end else begin
                    // Resume walking same direction
                    next_state = {WALK, direction};
                    next_fall_timer = 5'd0;
                end
            end else begin
                // Keep falling, increment fall_timer saturating at 31
                next_state = state;
                next_fall_timer = (fall_timer < 31) ? fall_timer + 1'b1 : fall_timer;
            end
        end

        WALK: begin
            if (!ground) begin
                // Start falling
                next_state = {FALL, direction};
                next_fall_timer = 5'd1;
            end else if (dig) begin
                // Start digging on ground
                next_state = {DIG, direction};
                next_fall_timer = 5'd0;
            end else begin
                // Handle bumps, change direction accordingly
                next_fall_timer = 5'd0;
                if (bump_left && bump_right)
                    next_state = {WALK, ~direction}; // toggle direction
                else if (bump_left)
                    next_state = {WALK, 1'b1}; // bump left -> walk right
                else if (bump_right)
                    next_state = {WALK, 1'b0}; // bump right -> walk left
                else
                    next_state = state;
            end
        end

        DIG: begin
            if (!ground) begin
                // Start falling from dig
                next_state = {FALL, direction};
                next_fall_timer = 5'd1;
            end else begin
                // Keep digging
                next_state = state;
                next_fall_timer = 5'd0;
            end
        end

        default: begin
            // Safety fallback: walk left
            next_state = {WALK, 1'b0};
            next_fall_timer = 5'd0;
        end
    endcase
end

assign walk_left  = (mode == WALK) && (direction == 1'b0);
assign walk_right = (mode == WALK) && (direction == 1'b1);
assign aaah       = (mode == FALL);
assign digging    = (mode == DIG);

endmodule