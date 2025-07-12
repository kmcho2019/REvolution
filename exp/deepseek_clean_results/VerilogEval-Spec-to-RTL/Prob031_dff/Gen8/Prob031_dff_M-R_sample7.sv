module TopModule (
    input clk,
    input d,
    output q
);

reg q_reg;
assign q = q_reg;

always @(clk or d) begin
    if (clk) q_reg <= d;  // Latches data when clk is high
end

endmodule