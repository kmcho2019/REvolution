module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [7:0] counter; // Counter to track time
reg [7:0] threshold; // Threshold value for toggling clock
reg clk_int; // Internal clock signal

initial begin
    counter = 0; // Initialize counter
    threshold = PERIOD / 2; // Calculate threshold value
    clk_int = 1'b0; // Initialize clock to 0
end

always #1 begin // Increment counter every time unit
    counter <= counter + 1;
    if (counter >= threshold) begin
        counter <= 0; // Reset counter
        clk_int <= ~clk_int; // Toggle clock
    end
end

assign clk = clk_int; // Assign internal clock to output

endmodule