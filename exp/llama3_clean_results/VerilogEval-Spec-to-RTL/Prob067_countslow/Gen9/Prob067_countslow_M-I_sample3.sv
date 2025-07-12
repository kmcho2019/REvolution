module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] count_reg;

always @(posedge clk) begin
    if (reset) begin
        count_reg <= 4'd0;
    end else if (slowena) begin
        count_reg <= (count_reg == 4'd9) ? 4'd0 : count_reg + 1;
    end
end

assign q = count_reg;

endmodule