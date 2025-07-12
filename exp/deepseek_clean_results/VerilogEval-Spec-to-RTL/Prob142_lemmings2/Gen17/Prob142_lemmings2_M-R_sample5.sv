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
    parameter LEFT = 2'b00;
    parameter RIGHT = 2'b01;
    parameter FALL_LEFT = 2'b10;
    parameter FALL_RIGHT = 2'b11;
    
    reg [1:0] state, next_state;

    // Next state logic (combinational)
    assign next_state = 
        (areset) ? LEFT :  // Async reset
        (!ground && (state == LEFT)) ? FALL_LEFT :
        (!ground && (state == RIGHT)) ? FALL_RIGHT :
        (ground && (state == FALL_LEFT)) ? LEFT :
        (ground && (state == FALL_RIGHT)) ? RIGHT :
        (state == LEFT && bump_left) ? RIGHT :
        (state == RIGHT && bump_right) ? LEFT :
        state;  // Default: stay in current state

    // State register (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end

    // Output logic
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule