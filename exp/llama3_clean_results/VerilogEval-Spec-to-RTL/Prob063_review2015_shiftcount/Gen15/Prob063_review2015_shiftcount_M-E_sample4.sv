module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] shift_reg = 4'b0;
reg [3:0] count_reg = 4'b0;
reg is_shift = 1'b0;

always @(posedge clk) begin
    if (shift_ena) begin
        shift_reg <= {data, shift_reg[3:1]};
        count_reg <= shift_reg;
        is_shift <= 1'b1;
    end else if (count_ena &&!is_shift) begin
        if (count_reg == 4'b0) begin
            count_reg <= 4'b1111;
        end else begin
            count_reg <= count_reg - 1;
        end
        is_shift <= 1'b0;
    end
end

assign q = count_reg;

endmodule