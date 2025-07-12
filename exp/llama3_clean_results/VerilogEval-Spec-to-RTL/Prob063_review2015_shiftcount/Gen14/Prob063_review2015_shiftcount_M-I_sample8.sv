module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] reg_out = 4'b0;

always @(posedge clk) begin
    if (shift_ena) begin
        reg_out <= {data, reg_out[3:1]};
    end else if (count_ena) begin
        reg_out <= (reg_out == 4'b0) ? 4'b1111 : (reg_out - 1);
    end
end

assign q = reg_out;

endmodule