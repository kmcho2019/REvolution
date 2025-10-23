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
    parameter LEFT = 2'b00;
    parameter RIGHT = 2'b01;
    parameter FALLING = 2'b10;
    
    reg [1:0] state, next_state;
    
    // State transition
    always @(*) begin
        case (state)
            LEFT: next_state = (!ground) ? FALLING : 
                              (bump_left) ? RIGHT : LEFT;
            RIGHT: next_state = (!ground) ? FALLING : 
                               (bump_right) ? LEFT : RIGHT;
            FALLING: next_state = (ground) ? state[0] ? RIGHT : LEFT : FALLING;
            default: next_state = LEFT;
        endcase
    end
    
    // State register
    always @(posedge clk, posedge areset) begin
        if (areset) state <= LEFT;
        else state <= next_state;
    end
    
    // Output logic
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALLING);

endmodule