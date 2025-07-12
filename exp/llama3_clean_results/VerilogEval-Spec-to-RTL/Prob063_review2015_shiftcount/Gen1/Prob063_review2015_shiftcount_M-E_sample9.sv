module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] shift_reg;
reg [3:0] count_reg;

always @(posedge clk) begin
    if (shift_ena) begin
        shift_reg[3:0] <= {data, shift_reg[3:1]};
    end else if (count_ena) begin
        count_reg <= count_reg - 1'b1;
    end
end

assign q = (shift_ena)? shift_reg : ((count_ena)? count_reg : 4'd0);

endmodule