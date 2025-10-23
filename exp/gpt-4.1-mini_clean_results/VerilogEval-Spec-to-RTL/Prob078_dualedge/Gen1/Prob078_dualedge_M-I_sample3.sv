module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_rising, q_falling;
reg edge_toggle;  // Toggles on every clock edge to indicate which q to output

// Capture data on rising edge
always @(posedge clk) begin
    q_rising <= d;
    edge_toggle <= ~edge_toggle;
    // Update q based on toggle indicating last edge sampled was rising or falling
    q <= edge_toggle ? q_falling : q_rising;
end

// Capture data on falling edge
always @(negedge clk) begin
    q_falling <= d;
end

endmodule