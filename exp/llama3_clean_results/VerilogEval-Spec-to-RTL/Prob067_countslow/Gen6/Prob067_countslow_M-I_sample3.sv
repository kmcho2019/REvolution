module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] q_reg;
reg clk_gated;

assign clk_gated = slowena? clk : 1'b0;

always @(posedge clk_gated or posedge reset) begin
    if (reset) begin
        q_reg <= 4'd0;
    end else if (slowena) begin
        if (q_reg == 4'd9) begin
            q_reg <= 4'd0;
        end else begin
            q_reg <= q_reg + 1'b1;
        end
    end
end

assign q = q_reg;

endmodule