module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] reg_q;

always @(posedge clk) begin
    if (shift_ena) begin
        reg_q <= {data, reg_q[3:1]};
    end else if (count_ena) begin
        if (reg_q == 4'b0) begin
            reg_q <= 4'b0; // Stop at zero
        end else begin
            reg_q <= reg_q - 1;
        end
    end else begin
        reg_q <= reg_q;
    end
end

assign q = reg_q;

endmodule