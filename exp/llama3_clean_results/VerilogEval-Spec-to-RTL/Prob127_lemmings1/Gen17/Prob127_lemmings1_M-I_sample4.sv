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
        if (bump_left && ~state) state <= 1; // Switch to walk right
        else if (bump_right && state) state <= 0; // Switch to walk left
    end
end

assign walk_left = ~state;
assign walk_right = state;

endmodule