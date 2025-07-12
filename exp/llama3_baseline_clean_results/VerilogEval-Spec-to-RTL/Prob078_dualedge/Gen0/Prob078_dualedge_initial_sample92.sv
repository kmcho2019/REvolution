module TopModule(
    input clk,
    input d,
    output reg q
);

reg prev_clk;  // To store the previous state of the clock
reg enable;    // Enable signal for the flip-flop

always @(posedge clk or negedge clk) begin
    prev_clk <= clk;  // Store the current clock state for the next cycle
end

always @(posedge clk) begin
    enable <= ~prev_clk;  // Enable is high when clk was low in the previous cycle (rising edge)
end

always @(negedge clk) begin
    enable <= prev_clk;  // Enable is high when clk was high in the previous cycle (falling edge)
end

always @(posedge enable) begin
    q <= d;  // Update q on the edge of the enable signal
end

endmodule