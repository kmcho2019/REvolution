module TopModule(
    input clk,
    input d,
    output q
);

reg rising_q, falling_q;

always @(posedge clk) begin
    rising_q <= d;
end

always @(negedge clk) begin
    falling_q <= d;
end

assign q = (clk) ? rising_q : falling_q;

endmodule