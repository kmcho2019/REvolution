module TopModule (
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
    // One-hot state encoding
    parameter WALK = 3'b001;
    parameter FALL = 3'b010;
    parameter DIG  = 3'b100;
    
    reg [2:0] state;
    reg direction; // 0=left, 1=right
    
    // Next state logic using continuous assignments
    wire walk_to_fall = (state == WALK) & ~ground;
    wire walk_to_dig  = (state == WALK) & ground & dig & ~walk_to_fall;
    wire dig_to_fall  = (state == DIG) & ~ground;
    wire fall_to_walk = (state == FALL) & ground;
    
    wire [2:0] next_state = walk_to_fall ? FALL :
                            walk_to_dig  ? DIG  :
                            dig_to_fall   ? FALL :
                            fall_to_walk  ? WALK :
                            state;
    
    // Direction update logic
    wire change_dir_left  = (state == WALK) & bump_left & ~direction;
    wire change_dir_right = (state == WALK) & bump_right & direction;
    wire next_direction = change_dir_right ? 1'b0 :
                          change_dir_left  ? 1'b1 :
                          direction;
    
    // State and direction registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // Start walking left
        end else begin
            state <= next_state;
            if (state == WALK) begin
                direction <= next_direction;
            end
        end
    end
    
    // Output logic
    assign walk_left  = (state == WALK) & ~direction;
    assign walk_right = (state == WALK) & direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);
    
endmodule