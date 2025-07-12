module TopModule(
    input clk,
    input d,
    output q
);

reg rising_edge_triggered;
reg falling_edge_triggered;
reg q_rising;
reg q_falling;

// Edge detection
always @(posedge clk) begin
    rising_edge_triggered <= 1'b1;
end

always @(negedge clk) begin
    rising_edge_triggered <= 1'b0;
end

// Dual-edge triggered flip-flops
always @(posedge clk) begin
    if (rising_edge_triggered) begin
        q_rising <= d;
    end
end

always @(negedge clk) begin
    q_falling <= d;
end

// Multiplexer to select the output
assign q = rising_edge_triggered? q_rising : q_falling;

endmodule