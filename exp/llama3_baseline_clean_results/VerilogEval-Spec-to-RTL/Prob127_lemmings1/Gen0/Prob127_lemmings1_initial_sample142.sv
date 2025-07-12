module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [1:0] state, next_state;

// Define states
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;

// Assign outputs based on state
assign walk_left = (state == WALK_LEFT) ? 1'b1 : 1'b0;
assign walk_right = (state == WALK_RIGHT) ? 1'b1 : 1'b0;

// Next state logic
always @(*) begin
    case(state)
        WALK_LEFT: 
            if(bump_left) 
                next_state = WALK_RIGHT;
            else 
                next_state = WALK_LEFT;
        WALK_RIGHT: 
            if(bump_right) 
                next_state = WALK_LEFT;
            else 
                next_state = WALK_RIGHT;
        default: 
            next_state = WALK_LEFT;
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if(areset) 
        state <= WALK_LEFT;
    else 
        state <= next_state;
end

endmodule