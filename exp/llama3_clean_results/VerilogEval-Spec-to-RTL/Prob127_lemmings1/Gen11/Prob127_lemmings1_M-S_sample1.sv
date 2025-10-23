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
        state <= 1'b0;  // Initial state: LEFT
    end else begin
        if ((state == 1'b0 && bump_left) || (state == 1'b1 && bump_right)) begin
            state <= ~state;  // Switch direction
        end
    end
end

assign walk_left = ~state;  // 1 when state is LEFT (0)
assign walk_right = state;  // 1 when state is RIGHT (1)

endmodule