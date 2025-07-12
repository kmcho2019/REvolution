module TopModule (
    input clk,
    input d,
    output q
);

reg q_reg;
wire #1 q = q_reg;  // Model clock-to-q delay (non-synthesizable)

always @(posedge clk) begin
    q_reg <= d;
end

endmodule