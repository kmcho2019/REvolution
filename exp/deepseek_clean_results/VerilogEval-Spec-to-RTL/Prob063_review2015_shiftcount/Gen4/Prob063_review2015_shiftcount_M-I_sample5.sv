module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

reg shift_ena_reg, count_ena_reg;
reg data_reg;
wire clk_en = shift_ena | count_ena;
wire gated_clk = clk & clk_en;

always @(posedge clk) begin
    shift_ena_reg <= shift_ena;
    count_ena_reg <= count_ena;
    data_reg <= data;
end

always @(posedge gated_clk) begin
    if (shift_ena_reg)
        q <= {q[2:0], data_reg};
    else if (count_ena_reg)
        q <= q - 1'b1;
    // else hold value (implicit through clock gating)
end

endmodule