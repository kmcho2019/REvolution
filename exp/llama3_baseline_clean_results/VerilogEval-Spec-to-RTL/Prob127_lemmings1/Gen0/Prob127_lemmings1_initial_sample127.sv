module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [1:0] state;
reg [1:0] next_state;

parameter walk_left_state = 0;
parameter walk_right_state = 1;

always @(*) begin
    case (state)
        walk_left_state: 
            if (bump_left) 
                next_state = walk_right_state;
            else 
                next_state = walk_left_state;
        walk_right_state: 
            if (bump_right) 
                next_state = walk_left_state;
            else 
                next_state = walk_right_state;
        default: 
            next_state = walk_left_state;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) 
        state <= walk_left_state;
    else 
        state <= next_state;
end

assign walk_left = (state == walk_left_state);
assign walk_right = (state == walk_right_state);

endmodule