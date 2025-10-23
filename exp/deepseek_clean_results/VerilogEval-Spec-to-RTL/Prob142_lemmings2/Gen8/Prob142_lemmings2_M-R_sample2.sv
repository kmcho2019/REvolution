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

    // Explicit state encoding
    parameter LEFT = 2'b00;
    parameter RIGHT = 2'b01;
    parameter FALL_LEFT = 2'b10;
    parameter FALL_RIGHT = 2'b11;
    
    reg [1:0] state, next_state;
    
    // Next state logic using assign
    assign next_state = 
        (state == LEFT) ? (ground ? (bump_left ? RIGHT : LEFT) : FALL_LEFT) :
        (state == RIGHT) ? (ground ? (bump_right ? LEFT : RIGHT) : FALL_RIGHT) :
        (state == FALL_LEFT) ? (ground ? LEFT : FALL_LEFT) :
        (state == FALL_RIGHT) ? (ground ? RIGHT : FALL_RIGHT) :
        LEFT;  // default case (shouldn't occur)
    
    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end
        else begin
            state <= next_state;
        end
    end
    
    // Output logic using simple assignments
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);

endmodule