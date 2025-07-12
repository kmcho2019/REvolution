module TopModule(
    input clk,
    input d,
    output reg q
);

reg prev_clk;  // Previous clock edge
reg clock_enable;  // Clock enable signal

// Store the previous clock edge
always @(posedge clk or negedge clk) begin
    prev_clk <= clk;
end

// Generate the clock enable signal
assign clock_enable = (clk ^ prev_clk);

// Single flip-flop with clock enable
always @(posedge clk) begin
    if (clock_enable) begin
        q <= d;
    end
end

endmodule