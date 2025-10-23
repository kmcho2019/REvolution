module TopModule(
    input clk,
    input d,
    output q
);

reg q_rise, q_fall;

always @(posedge clk)
    q_rise <= d;

always @(negedge clk)
    q_fall <= d;

assign q = (clk) ? q_rise : q_fall;

endmodule