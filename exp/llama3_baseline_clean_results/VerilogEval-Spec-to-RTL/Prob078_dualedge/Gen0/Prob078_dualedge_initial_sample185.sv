module TopModule(
    input clk,
    input d,
    output q
);

reg q_rising; // Output of the rising edge triggered flip-flop
reg q_falling; // Output of the falling edge triggered flip-flop
reg sel; // Select line for the multiplexer, toggles on every edge of clk

always @(posedge clk) begin
    q_rising <= d; // Capture d on rising edge
    sel <= ~sel; // Toggle sel on rising edge
end

always @(negedge clk) begin
    q_falling <= d; // Capture d on falling edge
    sel <= ~sel; // Toggle sel on falling edge
end

assign q = sel? q_rising : q_falling; // Use sel to select the output

endmodule