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
    
    // Next state logic (optimized)
    wire next_state = state ? (ground ? 0 : 1) : (ground ? 0 : 1);
    
    // Next direction logic (simplified XOR)
    wire next_direction = (state || !ground) ? direction : 
                         (direction ^ (direction ? bump_right : bump_left));
    
    // State and direction registers with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 0;         // Start in WALK state
            direction <= 0;     // Start walking left
        end
        else begin
            state <= next_state;
            if (!state && ground) direction <= next_direction;  // Only update when walking on ground
        end
    end
    
    // Output logic (optimized)
    assign walk_left = ~state & ~direction;
    assign walk_right = ~state & direction;
    assign aaah = state;

endmodule