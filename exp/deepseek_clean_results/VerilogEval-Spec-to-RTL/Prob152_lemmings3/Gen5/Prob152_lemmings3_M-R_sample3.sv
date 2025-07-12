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
    parameter WALK_LEFT = 4'b0001;
    parameter WALK_RIGHT = 4'b0010;
    parameter FALL = 4'b0100;
    parameter DIG = 4'b1000;
    
    reg [3:0] state;
    wire [3:0] next_state;
    
    // Next state logic using continuous assignments
    assign next_state = 
        (state == WALK_LEFT) ? 
            (~ground ? FALL : 
             (dig ? DIG : 
              (bump_left ? WALK_RIGHT : WALK_LEFT))) :
        (state == WALK_RIGHT) ? 
            (~ground ? FALL : 
             (dig ? DIG : 
              (bump_right ? WALK_LEFT : WALK_RIGHT))) :
        (state == FALL) ? 
            (ground ? (state[0] ? WALK_LEFT : WALK_RIGHT) : FALL) :
        (state == DIG) ? 
            (~ground ? FALL : DIG) :
        WALK_LEFT; // Default to WALK_LEFT (should never happen)
    
    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end
    
    // Output logic - direct from state bits
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);
    
endmodule