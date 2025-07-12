module TopModule(
    input         clk,
    input         areset,
    input         bump_left,
    input         bump_right,
    output        walk_left,
    output        walk_right
);

reg [0:0] state; // current state
reg [0:0] next_state; // next state

// assign outputs based on current state
assign walk_left = (state == 0)? 1'b1 : 1'b0;
assign walk_right = (state == 1)? 1'b1 : 1'b0;

// combinational logic to determine next state
always @(*)
begin
    case(state)
        0: // walking left
            if(bump_left)
                next_state = 1; // switch to walking right
            else
                next_state = 0; // stay walking left
        1: // walking right
            if(bump_right)
                next_state = 0; // switch to walking left
            else
                next_state = 1; // stay walking right
        default:
            next_state = 0; // default to walking left
    endcase
end

// sequential logic to update state
always @(posedge clk or posedge areset)
begin
    if(areset)
        state <= 0; // reset to walking left
    else
        state <= next_state; // update state
end

endmodule