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

    // Direction constants
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg direction;  // Current walking direction
    reg falling;    // Falling state flag
    
    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= LEFT;  // Start walking left
            falling <= 0;
        end
        else begin
            if (!falling) begin
                // Handle ground transitions when not falling
                if (!ground) begin
                    falling <= 1;
                end
                else begin
                    // Handle bump events only when on ground
                    case (direction)
                        LEFT:  if (bump_left)  direction <= RIGHT;
                        RIGHT: if (bump_right) direction <= LEFT;
                    endcase
                end
            end
            else begin
                // Handle ground return when falling
                if (ground) begin
                    falling <= 0;
                end
            end
        end
    end
    
    // Output logic - Moore style (outputs depend only on current state)
    assign walk_left = (~falling) & (direction == LEFT);
    assign walk_right = (~falling) & (direction == RIGHT);
    assign aaah = falling;

endmodule