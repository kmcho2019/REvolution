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
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg direction;  // LEFT or RIGHT
    reg falling;
    
    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= LEFT;
            falling <= 1'b0;
        end
        else begin
            // Handle falling first (highest priority)
            if (falling) begin
                if (ground) falling <= 1'b0;
            end
            else if (!ground) begin
                falling <= 1'b1;
            end
            // Only change direction when on ground and not falling
            else if ((direction == LEFT && bump_left) || 
                    (direction == RIGHT && bump_right)) begin
                direction <= direction ^ 1'b1;  // Toggle direction
            end
        end
    end
    
    // Output logic (continuous assignments)
    assign walk_left = ~falling & (direction == LEFT);
    assign walk_right = ~falling & (direction == RIGHT);
    assign aaah = falling;
endmodule