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

    // One-hot state encoding
    parameter WALK_LEFT  = 4'b0001;
    parameter WALK_RIGHT = 4'b0010;
    parameter FALL       = 4'b0100;
    
    reg [3:0] state;
    reg direction;  // 0 for left, 1 for right
    
    // Next state and direction logic
    wire [3:0] next_state;
    wire next_direction;
    
    assign next_state = 
        areset ? WALK_LEFT :
        (state == WALK_LEFT) ? 
            (!ground ? FALL : 
             bump_left ? WALK_RIGHT : WALK_LEFT) :
        (state == WALK_RIGHT) ? 
            (!ground ? FALL : 
             bump_right ? WALK_LEFT : WALK_RIGHT) :
        (state == FALL) ? 
            (ground ? (direction ? WALK_RIGHT : WALK_LEFT) : FALL) :
        WALK_LEFT;  // default
    
    assign next_direction = 
        areset ? 1'b0 :
        (state == WALK_LEFT && bump_left) ? 1'b1 :
        (state == WALK_RIGHT && bump_right) ? 1'b0 :
        (state == FALL) ? direction : 
        direction;
    
    // State and direction registers
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            direction <= 1'b0;
        end else begin
            state <= next_state;
            direction <= next_direction;
        end
    end
    
    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL);

endmodule