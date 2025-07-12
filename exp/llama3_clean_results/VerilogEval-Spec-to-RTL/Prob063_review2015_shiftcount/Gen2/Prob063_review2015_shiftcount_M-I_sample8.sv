module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] reg;

always @(posedge clk) begin
    if (shift_ena) begin
        reg <= {data, reg[3:1]};
    end else if (count_ena) begin
        reg <= reg - 1'b1;
    end
end

assign q = reg;

endmodule