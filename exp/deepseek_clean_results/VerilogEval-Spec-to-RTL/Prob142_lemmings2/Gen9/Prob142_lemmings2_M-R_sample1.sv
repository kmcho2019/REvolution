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
    // State encoding
    localparam IDLE_LEFT = 2'b00;
    localparam IDLE_RIGHT = 2'b01;
    localparam FALLING_LEFT = 2'b10;
    localparam FALLING_RIGHT = 2'b11;
    
    reg [1:0] state, next_state;
    
    // Next state logic
    assign next_state = 
        (areset) ? IDLE_LEFT :
        (!ground) ? (state[1] ? FALLING_RIGHT : FALLING_LEFT) :  // Start falling
        (state == FALLING_LEFT && ground) ? IDLE_LEFT :
        (state == FALLING_RIGHT && ground) ? IDLE_RIGHT :
        (state == IDLE_LEFT && bump_left) ? IDLE_RIGHT :
        (state == IDLE_RIGHT && bump_right) ? IDLE_LEFT :
        state;  // Default case
    
    // State register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= IDLE_LEFT;
        else
            state <= next_state;
    end
    
    // Output logic
    assign walk_left = (state == IDLE_LEFT);
    assign walk_right = (state == IDLE_RIGHT);
    assign aaah = state[1];  // MSB indicates falling state
endmodule