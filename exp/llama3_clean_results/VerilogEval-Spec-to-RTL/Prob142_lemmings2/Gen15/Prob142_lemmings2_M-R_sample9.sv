module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg [1:0] state; // 2 bits to represent the state (00: walking left, 01: walking right, 10: falling)
reg [1:0] next_state;

assign next_state = (ground) ? (state == 2'b10) ? {1'b0, state[0]} : 
                             ((bump_left && state == 2'b00) || (bump_right && state == 2'b01)) ? {1'b0, ~state[0]} : state :
                             {1'b1, state[0]};

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end else begin
        state <= next_state;
    end
end

assign walk_left = (state == 2'b00) ? 1'b1 : 1'b0;
assign walk_right = (state == 2'b01) ? 1'b1 : 1'b0;
assign aaah = (state[1] == 1'b1) ? 1'b1 : 1'b0;

endmodule