module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] state; // 0 for walking left, 1 for walking right
reg [0:0] next_state;

// Moore output
assign walk_left = (state == 0);
assign walk_right = (state == 1);

// Next state logic
always @(*) begin
    case (state)
        0: next_state = (bump_left) ? 1 : 0;
        1: next_state = (bump_right) ? 0 : 1;
        default: next_state = 0;
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Reset to walking left
    end else begin
        state <= next_state;
    end
end

endmodule