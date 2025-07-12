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
        state <= 0; // Walk left
    end else begin
        if (bump_left || bump_right) begin
            state <= ~state; // Switch direction
        end
    end
end

assign walk_left = ~state;
assign walk_right = state;

endmodule