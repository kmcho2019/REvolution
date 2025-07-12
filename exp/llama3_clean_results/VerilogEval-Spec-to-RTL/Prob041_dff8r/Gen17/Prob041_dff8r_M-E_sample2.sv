module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

logic [7:0] shift_reg;

always_ff @(posedge clk) begin
    if (reset) shift_reg <= '0;
    else shift_reg <= {shift_reg[6:0], d[0]};
end

always_ff @(posedge clk) begin
    if (reset) q <= '0;
    else q <= shift_reg;
end

endmodule