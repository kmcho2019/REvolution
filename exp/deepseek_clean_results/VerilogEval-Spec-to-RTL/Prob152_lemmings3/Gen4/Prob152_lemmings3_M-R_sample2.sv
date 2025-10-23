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
    
    reg [2:0] state;  // One-hot state
    reg direction;    // 0=left, 1=right
    
    // Next state logic (parallel assigns for better timing)
    wire fall_condition = ~ground;
    wire dig_condition = dig & ground;
    wire bump_condition = (~direction & bump_left) | (direction & bump_right);
    
    wire [2:0] next_state = 
        (state == WALK & fall_condition) ? FALL :
        (state == WALK & dig_condition)  ? DIG  :
        (state == FALL & ground)         ? WALK :
        (state == DIG  & fall_condition) ? FALL :
        state;  // Default: stay in current state
    
    // Next direction logic (only updates during WALK state)
    wire next_direction = 
        (state == WALK) ? ((bump_condition & ~fall_condition & ~dig_condition) ? ~direction : direction) :
        direction;
    
    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // Start walking left
        end else begin
            state <= next_state;
            direction <= next_direction;
        end
    end
    
    // Output logic - direct mapping from state bits
    assign walk_left  = state[0] & ~direction;
    assign walk_right = state[0] & direction;
    assign aaah       = state[1];
    assign digging    = state[2];
    
endmodule