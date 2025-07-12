module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0;
    end else if (state == 1'b0 && x == 1'b1) begin
        state <= 1'b1;
    end
end

assign z = (state == 1'b0)? x : ~x;

endmodule