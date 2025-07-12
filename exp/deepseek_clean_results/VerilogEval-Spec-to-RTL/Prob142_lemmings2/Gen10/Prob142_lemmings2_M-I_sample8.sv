module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    reg state;      // 0=WALK, 1=FALL
    reg direction;  // 0=left, 1=right
    reg walk_left_reg, walk_right_reg, aaah_reg;
    wire ground_falling = !ground;
    wire ground_rising = ground && state;

    // State and direction update
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 0;         // WALK state
            direction <= 0;     // Left direction
        end
        else begin
            // State transition (parallel path)
            if (ground_falling) state <= 1;
            else if (ground_rising) state <= 0;
        end
    end

    // Direction update (separate path)
    always @(posedge clk) begin
        if (!state && ground) begin // Only update when walking on ground
            case ({bump_left, bump_right})
                2'b10: direction <= 1; // Bump left -> go right
                2'b01: direction <= 0; // Bump right -> go left
                2'b11: direction <= ~direction; // Both bumps -> toggle
                default: ; // No change
            endcase
        end
    end

    // Registered outputs with clock gating
    always @(posedge clk) begin
        if (areset || state != walk_left_reg || direction != walk_right_reg) begin
            walk_left_reg <= ~state & ~direction;
            walk_right_reg <= ~state & direction;
            aaah_reg <= state;
        end
    end

    assign walk_left = walk_left_reg;
    assign walk_right = walk_right_reg;
    assign aaah = aaah_reg;

endmodule