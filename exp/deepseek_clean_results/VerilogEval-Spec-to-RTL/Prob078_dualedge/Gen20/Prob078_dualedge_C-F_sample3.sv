module TopModule (
    input clk,
    input d,
    output q
);

reg q_p, q_n;

always @(posedge clk) q_p <= d;
always @(negedge clk) q_n <= d;

assign q = clk ? q_p : q_n;

endmodule