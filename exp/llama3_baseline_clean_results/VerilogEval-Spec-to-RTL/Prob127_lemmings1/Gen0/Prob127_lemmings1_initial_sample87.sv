module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] state; // 1-bit state register
parameter walking_left = 1'b0, walking_right = 1'b1;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= walking_left;
    end else begin
        if (bump_left || bump_right) begin
            state <= ~state;
        end
    end
end

assign walk_left = (state == walking_left) ? 1'b1 : 1'b0;
assign walk_right = (state == walking_right) ? 1'b1 : 1'b0;

endmodule