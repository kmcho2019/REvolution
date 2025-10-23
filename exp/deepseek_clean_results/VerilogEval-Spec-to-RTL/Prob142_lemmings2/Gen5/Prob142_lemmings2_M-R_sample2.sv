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

    // State definitions
    reg walking;  // 1=WALK, 0=FALL
    reg direction;  // 0=left, 1=right
    
    // Next state and direction logic
    wire next_walking;
    wire next_direction;
    
    // State transition logic
    assign next_walking = walking ? (ground ? 1'b1 : 1'b0)  // Stay in WALK if ground=1
                                  : (ground ? 1'b1 : 1'b0); // Return to WALK when ground=1
    
    // Direction update logic (only changes when walking and ground=1)
    assign next_direction = (walking && ground) ? 
                          ((!direction && bump_left) || (direction && bump_right) ? ~direction : direction
                          : direction;  // Maintain direction when falling
    
    // State and direction registers with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walking <= 1'b1;  // Start in WALK state
            direction <= 1'b0;  // Start walking left
        end else begin
            walking <= next_walking;
            direction <= next_direction;
        end
    end
    
    // Output logic
    assign walk_left = walking && ~direction;
    assign walk_right = walking && direction;
    assign aaah = ~walking;

endmodule