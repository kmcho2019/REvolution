module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

reg shift_ena_reg, count_ena_reg;
wire operation_en = shift_ena_reg | count_ena_reg;

always @(posedge clk) begin
    shift_ena_reg <= shift_ena;
    count_ena_reg <= count_ena;
end

always @(posedge clk) begin
    if (shift_ena_reg) begin
        q <= {q[2:0], data};
    end
    else if (count_ena_reg) begin
        q <= q - 1'b1;
    end
    // Implicit else holds value (clock gated by operation_en in synthesis)
end

endmodule