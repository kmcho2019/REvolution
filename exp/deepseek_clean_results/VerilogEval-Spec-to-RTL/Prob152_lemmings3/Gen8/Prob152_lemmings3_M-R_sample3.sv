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
    parameter WALKING = 3'b001;
    parameter FALLING = 3'b010;
    parameter DIGGING = 3'b100;
    
    reg [2:0] state;
    reg direction; // 0=left, 1=right

    // Next state logic (combinational)
    wire walking_next = (state == FALLING) ? ground : 
                       (state == DIGGING) ? !ground : 
                       (state == WALKING) ? (ground && !dig) : 1'b0;
    
    wire falling_next = (state == WALKING) ? !ground : 
                       (state == DIGGING) ? !ground : 
                       (state == FALLING) ? !ground : 1'b0;
    
    wire digging_next = (state == WALKING) ? (ground && dig) : 
                       (state == DIGGING) ? ground : 1'b0;

    // Direction update logic (only in WALKING state)
    wire direction_change = (state == WALKING) && 
                          ((bump_left && !direction) || (bump_right && direction));
    wire next_direction = direction_change ? ~direction : direction;

    // State and direction registers with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALKING;
            direction <= 1'b0; // start walking left
        end else begin
            state <= {digging_next, falling_next, walking_next};
            direction <= next_direction;
        end
    end

    // Output logic
    assign walk_left = (state == WALKING) & ~direction;
    assign walk_right = (state == WALKING) & direction;
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);

endmodule