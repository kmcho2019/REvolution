module TopModule(
    input  clk,
    input  d,
    output q
);

reg phase;
reg q_rising;
reg q_falling;

initial phase = 1'b0;

always @(posedge clk) begin
    phase <= ~phase;
    if (~phase) q_rising <= d;
end

always @(negedge clk) begin
    if (phase) q_falling <= d;
end

assign q = (phase) ? q_rising : q_falling;

endmodule