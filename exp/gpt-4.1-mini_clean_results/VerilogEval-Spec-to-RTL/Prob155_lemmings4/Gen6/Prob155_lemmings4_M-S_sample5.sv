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

// Mode encoding
localparam MODE_WALK  = 2'd0;
localparam MODE_DIG   = 2'd1;
localparam MODE_FALL  = 2'd2;
localparam MODE_SPLAT = 2'd3;

// Direction encoding
localparam DIR_LEFT  = 1'b0;
localparam DIR_RIGHT = 1'b1;

reg [1:0] mode;
reg direction;         // 0=left, 1=right
reg [4:0] fall_timer;  // counts falling cycles

wire bumped = bump_left | bump_right;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= MODE_WALK;
        direction <= DIR_LEFT;
        fall_timer <= 5'd0;
    end else begin
        case (mode)
            MODE_SPLAT: begin
                // Remain splatted
                mode <= MODE_SPLAT;
                fall_timer <= 5'd0;
                // direction unchanged
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed: splatter if fallen >20 cycles
                    if (fall_timer > 5'd20) begin
                        mode <= MODE_SPLAT;
                    end else begin
                        mode <= MODE_WALK;
                    end
                    fall_timer <= 5'd0;
                    // direction unchanged
                end else begin
                    mode <= MODE_FALL;
                    // saturate at max 31
                    fall_timer <= (fall_timer < 5'd31) ? fall_timer + 1'b1 : fall_timer;
                    // direction unchanged
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    mode <= MODE_FALL;
                    fall_timer <= 5'd1;
                    // direction unchanged
                end else if (dig) begin
                    mode <= MODE_DIG;
                    fall_timer <= 5'd0;
                    // direction unchanged
                end else begin
                    mode <= MODE_WALK;
                    fall_timer <= 5'd0;
                    // Change direction on bumps
                    if (bump_left && bump_right) begin
                        direction <= ~direction;
                    end else if (bump_left) begin
                        direction <= DIR_RIGHT;
                    end else if (bump_right) begin
                        direction <= DIR_LEFT;
                    end
                    // else keep direction
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    mode <= MODE_FALL;
                    fall_timer <= 5'd1;
                    // direction unchanged
                end else begin
                    mode <= MODE_DIG;
                    fall_timer <= 5'd0;
                    // direction unchanged
                end
            end

            default: begin
                mode <= MODE_WALK;
                direction <= DIR_LEFT;
                fall_timer <= 5'd0;
            end
        endcase
    end
end

// Outputs (Moore style)
assign walk_left  = (mode == MODE_WALK) && (direction == DIR_LEFT);
assign walk_right = (mode == MODE_WALK) && (direction == DIR_RIGHT);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule