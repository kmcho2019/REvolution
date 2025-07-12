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
    reg bump_left_sync, bump_right_sync;

    // Register bump inputs for better timing
    always @(posedge clk) begin
        bump_left_sync <= bump_left;
        bump_right_sync <= bump_right;
    end

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 0;         // WALK state
            direction <= 0;     // Left direction
        end
        else begin
            // State transition (parallel path)
            if (state) begin    // FALL state
                if (ground) state <= 0;
            end
            else if (!ground) begin // WALK->FALL transition
                state <= 1;
            end

            // Direction update (parallel path with gating)
            if (!state && ground) begin // Only update direction when walking on ground
                if ((!direction && bump_left_sync) || 
                    (direction && bump_right_sync)) begin
                    direction <= !direction; // Direct toggle
                end
            end
        end
    end

    // Output logic - optimized Moore style
    assign walk_left = (~state) & (~direction);
    assign walk_right = (~state) & direction;
    assign aaah = state;

endmodule