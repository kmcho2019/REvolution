module TopModule (
    input clk,
    input d,
    output q
);

reg prev_clk;
wire posedge_pulse = clk & ~prev_clk;
wire negedge_pulse = ~clk & prev_clk;

reg q_pos, q_neg;

always @(*) begin
    if (posedge_pulse) q_pos = d;
    if (negedge_pulse) q_neg = d;
    prev_clk = clk;
end

assign q = clk ? q_pos : q_neg;

endmodule