module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] state_reg;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 4'd0;
    end else if (slowena) begin
        state_reg <= (state_reg == 4'd9) ? 4'd0 : state_reg + 1'b1;
    end
end

assign q = state_reg;

endmodule