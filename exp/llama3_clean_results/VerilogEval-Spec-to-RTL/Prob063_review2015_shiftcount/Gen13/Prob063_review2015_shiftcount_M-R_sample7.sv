module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] reg_out = 4'b0;

always @(posedge clk) begin
    reg [3:0] next_reg_out;
    if (shift_ena) begin
        next_reg_out = {data, reg_out[3:1]};
    end else if (count_ena) begin
        if (reg_out == 4'b0) begin
            next_reg_out = 4'b1111;
        end else begin
            next_reg_out = reg_out - 1;
        end
    end else begin
        next_reg_out = reg_out;
    end
    reg_out <= next_reg_out;
end

assign q = reg_out;

endmodule