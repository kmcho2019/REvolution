module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] reg_value = 4'b0;

always @(posedge clk) begin
    if (shift_ena) begin
        reg_value <= {data, reg_value[3:1]};
    end else if (count_ena) begin
        if (reg_value == 4'b0) begin
            reg_value <= 4'b1111;
        end else begin
            reg_value <= reg_value - 1;
        end
    end
end

assign q = reg_value;

endmodule