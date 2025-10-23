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

// Mode encoding using localparams for clarity
localparam MODE_WALK = 2'd0;
localparam MODE_FALL = 2'd1;
localparam MODE_DIG  = 2'd2;

reg dir;   // 0 = left, 1 = right
reg [1:0] mode;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        dir <= 1'b0;       // walking left on reset
        mode <= MODE_WALK; // walking mode on reset
    end else begin
        case (mode)
            MODE_WALK: begin
                if (!ground) begin
                    // Falling takes precedence
                    mode <= MODE_FALL;
                    // direction stays the same
                end else if (dig) begin
                    // Start digging if on ground and walking
                    mode <= MODE_DIG;
                end else begin
                    // Handle bumps only if not falling or digging
                    if (bump_left && bump_right) begin
                        // bump both sides: flip direction
                        dir <= ~dir;
                    end else if (bump_left) begin
                        // bump left: walk right
                        dir <= 1'b1;
                    end else if (bump_right) begin
                        // bump right: walk left
                        dir <= 1'b0;
                    end
                    // remain walking mode
                    mode <= MODE_WALK;
                end
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed, resume walking with same dir
                    mode <= MODE_WALK;
                end
                // else remain falling, no direction change
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Edge reached, start falling
                    mode <= MODE_FALL;
                end
                // else keep digging
            end

            default: begin
                // should never get here, reset to walk left
                dir <= 1'b0;
                mode <= MODE_WALK;
            end
        endcase
    end
end

assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule