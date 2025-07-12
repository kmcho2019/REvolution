module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] reg_out = 4'b0;

wire [3:0] shift_reg_out = {data, reg_out[3:1]};
wire [3:0] count_reg_out = (reg_out == 4'b0) ? 4'b1111 : reg_out - 1;
wire [3:0] next_reg_out = (shift_ena) ? shift_reg_out : (count_ena) ? count_reg_out : reg_out;

always @(posedge clk) begin
    reg_out <= next_reg_out;
end

assign q = reg_out;

endmodule