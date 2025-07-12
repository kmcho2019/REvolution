module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 4'd0;
    end else if (slowena && q_reg != 4'd9) begin
        q_reg <= q_reg + 1'b1;
    end else if (slowena && q_reg == 4'd9) begin
        q_reg <= 4'd0;
    end
end

assign q = q_reg;

endmodule