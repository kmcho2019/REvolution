module TopModule(
    input clk,
    input d,
    output reg q
);

reg prev_clk;  // Previous clock value

// Update output q on both edges of the clock
always @(posedge clk or negedge clk) begin
    if (clk != prev_clk) begin  // Check for clock edge
        q <= d;  // Update output q
    end
    prev_clk <= clk;  // Update previous clock value
end

endmodule