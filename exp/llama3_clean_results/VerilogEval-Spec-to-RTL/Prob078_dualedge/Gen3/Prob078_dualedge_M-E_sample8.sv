module TopModule(
    input clk,
    input d,
    output q
);

reg [1:0] phase_shifted_clk;
reg q_reg;

always @(posedge clk) begin
    phase_shifted_clk <= {phase_shifted_clk[0], 1'b1};
end

always @(negedge clk) begin
    phase_shifted_clk <= {phase_shifted_clk[0], 1'b0};
end

always @(posedge clk or posedge phase_shifted_clk[0]) begin
    q_reg <= d;
end

assign q = q_reg;

endmodule