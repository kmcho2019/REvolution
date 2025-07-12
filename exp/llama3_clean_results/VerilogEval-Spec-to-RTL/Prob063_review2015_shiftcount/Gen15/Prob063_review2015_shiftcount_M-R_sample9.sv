module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] shift_reg = 4'b0000;
reg [3:0] count_reg = 4'b0000;

always @(posedge clk) begin
    if (shift_ena) begin
        shift_reg <= {data, shift_reg[3:1]};
    end
    if (count_ena) begin
        if (count_reg == 4'b0000) begin
            count_reg <= 4'b0000; // Prevents counting below 0
        end else begin
            count_reg <= count_reg - 1;
        end
    end
end

assign q = (shift_ena) ? shift_reg : (count_ena) ? count_reg : shift_reg;

endmodule