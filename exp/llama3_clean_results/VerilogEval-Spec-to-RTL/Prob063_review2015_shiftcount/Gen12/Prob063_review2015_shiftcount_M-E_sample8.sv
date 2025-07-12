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
        if (reg_out == 4'b0) begin
            reg_out <= 4'b1111;  // Wrap around to maximum value
        end else begin
            reg_out <= reg_out - 1;
        end
    end
end

assign q = reg_out;

endmodule