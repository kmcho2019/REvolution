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

localparam WALK = 2'd0;
localparam DIG  = 2'd1;
localparam FALL = 2'd2;
localparam SPLAT= 2'd3;

reg [1:0] mode, next_mode;
reg direction, next_direction; // 0=left,1=right
reg [4:0] fall_timer, next_fall_timer;

// Sequential logic with async reset
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= WALK;
        direction <= 1'b0;  // walk left initially
        fall_timer <= 5'd0;
    end else begin
        mode <= next_mode;
        direction <= next_direction;
        fall_timer <= next_fall_timer;
    end
end

// Next state combinational logic
always_comb begin
    // Default: hold current state
    next_mode = mode;
    next_direction = direction;
    next_fall_timer = fall_timer;

    case (mode)
        SPLAT: begin
            // Remain splatted indefinitely
            next_mode = SPLAT;
            next_fall_timer = 5'd0;
            // direction irrelevant
        end

        FALL: begin
            if (ground) begin
                if (fall_timer > 5'd20) begin
                    next_mode = SPLAT;
                    next_fall_timer = 5'd0;
                end else begin
                    next_mode = WALK;
                    next_fall_timer = 5'd0;
                end
                // direction unchanged
                next_direction = direction;
            end else begin
                // Continue falling, saturate fall_timer at 21
                next_mode = FALL;
                next_direction = direction;
                next_fall_timer = (fall_timer < 5'd21) ? fall_timer + 1'b1 : fall_timer;
            end
        end

        WALK: begin
            if (!ground) begin
                next_mode = FALL;
                next_fall_timer = 5'd1; // start count at 1 on fall
                next_direction = direction; // preserve direction
            end else if (dig) begin
                next_mode = DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end else begin
                // Handle bump logic: highest precedence is bump_left and bump_right both
                if (bump_left && bump_right) begin
                    // Toggle direction
                    next_direction = ~direction;
                end else if (bump_left) begin
                    next_direction = 1'b1; // walk right
                end else if (bump_right) begin
                    next_direction = 1'b0; // walk left
                end else begin
                    next_direction = direction;
                end
                next_mode = WALK;
                next_fall_timer = 5'd0;
            end
        end

        DIG: begin
            if (!ground) begin
                next_mode = FALL;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else begin
                next_mode = DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
                // bump and dig inputs ignored while digging on ground
            end
        end

        default: begin
            // Defensive fallback
            next_mode = WALK;
            next_direction = 1'b0;
            next_fall_timer = 5'd0;
        end
    endcase
end

assign walk_left = (mode == WALK) && (direction == 1'b0);
assign walk_right= (mode == WALK) && (direction == 1'b1);
assign aaah      = (mode == FALL);
assign digging   = (mode == DIG);

endmodule