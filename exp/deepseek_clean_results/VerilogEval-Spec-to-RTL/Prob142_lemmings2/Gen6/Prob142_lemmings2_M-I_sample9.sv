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

    // Next state and direction logic
    always @(*) begin
        // Default assignments
        state = state;
        direction = direction;
        
        if (state) begin // FALL state
            if (ground) state = 0; // Return to WALK
        end
        else begin // WALK state
            if (!ground) begin
                state = 1; // Start FALL
            end
            else begin // Only update direction when walking on ground
                case ({bump_left, bump_right})
                    2'b10:   direction = 1; // Bump left, go right
                    2'b01:   direction = 0; // Bump right, go left
                    2'b11:   direction = ~direction; // Bump both, toggle
                    default: direction = direction; // No change
                endcase
            end
        end
    end

    // State and direction registers with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 0;      // Start in WALK state
            direction <= 0;  // Start walking left
        end
        else begin
            state <= state;
            direction <= direction;
        end
    end

    // Output logic
    assign walk_left = ~state & ~direction;
    assign walk_right = ~state & direction;
    assign aaah = state;

endmodule