module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

reg state; // State variable, 0 for LEFT, 1 for RIGHT

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Initialize state to LEFT
    end else begin
        state <= (state == 0 && bump_left) || (state == 1 && bump_right)? ~state : state;
    end
end

assign walk_left = ~state;
assign walk_right = state;

endmodule