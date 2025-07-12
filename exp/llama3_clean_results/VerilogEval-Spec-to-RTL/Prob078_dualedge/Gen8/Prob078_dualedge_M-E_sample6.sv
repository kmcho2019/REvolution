module TopModule(
    input clk,
    input d,
    output reg q
);

reg prev_clk;  // Previous clock value
reg data_reg;  // Registered input data

// Detect rising and falling edges
always @(posedge clk or negedge clk) begin
    prev_clk <= clk;
end

// Register input data on both rising and falling edges
always @(posedge clk or negedge clk) begin
    if (clk != prev_clk) begin  // Edge detection
        data_reg <= d;
    end
end

// Update output
always @(posedge clk) begin
    q <= data_reg;
end

endmodule