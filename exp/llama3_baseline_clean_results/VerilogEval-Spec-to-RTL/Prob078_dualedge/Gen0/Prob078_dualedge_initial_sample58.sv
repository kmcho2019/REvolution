module TopModule(
    input clk,
    input d,
    output q
);

reg rising_q, falling_q;
reg clock_phase;

always @(posedge clk) begin
    rising_q <= d;
    clock_phase <= 1'b1;
end

always @(negedge clk) begin
    falling_q <= d;
    clock_phase <= 1'b0;
end

assign q = (clock_phase) ? rising_q : falling_q;

endmodule