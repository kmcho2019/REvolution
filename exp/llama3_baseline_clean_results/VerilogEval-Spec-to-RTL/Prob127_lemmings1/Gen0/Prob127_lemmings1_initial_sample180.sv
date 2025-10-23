module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] state; // current state
reg [0:0] next_state; // next state

// Define the states
parameter WALK_LEFT = 1'b0;
parameter WALK_RIGHT = 1'b1;

// Output logic
assign walk_left = (state == WALK_LEFT)? 1'b1 : 1'b0;
assign walk_right = (state == WALK_RIGHT)? 1'b1 : 1'b0;

// Next state logic
always @(*)
begin
    case(state)
        WALK_LEFT:
            if (bump_left)
                next_state = WALK_RIGHT;
            else
                next_state = state;
        WALK_RIGHT:
            if (bump_right)
                next_state = WALK_LEFT;
            else
                next_state = state;
        default: next_state = WALK_LEFT;
    endcase
end

// State register
always @(posedge clk or posedge areset)
begin
    if (areset)
        state <= WALK_LEFT;
    else
        state <= next_state;
end

endmodule