module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] reg_value;

always @(posedge clk) begin
    if (shift_ena) begin
        reg_value <= {data, reg_value[3:1]};
    end else if (count_ena) begin
        reg_value <= reg_value - 1'b1;
    end
end

assign q = reg_value;

endmodule