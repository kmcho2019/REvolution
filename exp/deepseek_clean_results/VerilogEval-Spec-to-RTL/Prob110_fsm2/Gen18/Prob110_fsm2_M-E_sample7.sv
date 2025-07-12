module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg state;  // 0 = OFF, 1 = ON
wire toggle_enable = (j & ~state) | (k & state);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0;
    end else if (toggle_enable) begin
        state <= ~state;
    end
end

assign out = state;

endmodule