module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count_reg;

assign q = count_reg;

always @(posedge clk) begin
    if (reset) begin
        count_reg <= 4'b0;
    end else begin
        count_reg <= count_reg + 1'b1;
    end
end

endmodule