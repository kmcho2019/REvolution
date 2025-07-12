module TopModule(
    input clk,
    input d,
    output reg q
);

reg prev_clk;  // Store the previous clock value to detect edges
reg sampled_d;  // Sampled input value

// Detect clock edges and sample input
always @(posedge clk or negedge clk) begin
    prev_clk <= clk;
    sampled_d <= d;
end

// Update output based on sampled input
always @(posedge clk) begin
    if (prev_clk != clk) begin  // Update q if a clock edge occurred
        q <= sampled_d;
    end
end

endmodule