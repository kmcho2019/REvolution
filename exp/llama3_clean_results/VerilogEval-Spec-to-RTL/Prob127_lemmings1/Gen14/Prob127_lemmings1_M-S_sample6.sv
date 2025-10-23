module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0; // walk left
    end else if (bump_left) begin
        state <= 1'b1; // walk right
    end else if (bump_right) begin
        state <= 1'b0; // walk left
    end
end

assign walk_left = ~state;
assign walk_right = state;

endmodule