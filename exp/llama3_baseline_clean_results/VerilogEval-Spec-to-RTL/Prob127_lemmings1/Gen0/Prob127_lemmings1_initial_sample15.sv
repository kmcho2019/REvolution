module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] state;
reg [0:0] next_state;

parameter S_LEFT = 1'b0;
parameter S_RIGHT = 1'b1;

always @(posedge clk or posedge areset)
begin
    if (areset)
        state <= S_LEFT;
    else
        state <= next_state;
end

always @(*)
begin
    case(state)
        S_LEFT:
            if (bump_right || bump_left)
                next_state = S_RIGHT;
            else
                next_state = S_LEFT;
        S_RIGHT:
            if (bump_right || bump_left)
                next_state = S_LEFT;
            else
                next_state = S_RIGHT;
    endcase
end

assign walk_left = (state == S_LEFT) ? 1'b1 : 1'b0;
assign walk_right = (state == S_RIGHT) ? 1'b1 : 1'b0;

endmodule