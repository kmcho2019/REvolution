module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

reg state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Initialize state to LEFT (0)
    end else begin
        state <= (bump_left &&!state) || (!bump_right && state);
    end
end

assign walk_left = ~state;
assign walk_right = state;

endmodule