module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0; // LEFT state
    end else if (bump_left && bump_right) begin
        state <= ~state; // Switch direction
    end else if (state == 1'b0 && bump_left) begin
        state <= 1'b1; // Switch to RIGHT state
    end else if (state == 1'b1 && bump_right) begin
        state <= 1'b0; // Switch to LEFT state
    end
end

assign walk_left = ~state;
assign walk_right = state;

endmodule