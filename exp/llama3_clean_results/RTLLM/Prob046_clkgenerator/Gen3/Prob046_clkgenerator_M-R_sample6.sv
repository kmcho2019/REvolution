module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk // Generated clock signal
);

reg [31:0] counter; // Counter to track the number of time steps
reg [31:0] threshold; // Threshold value based on the desired period

initial begin
    threshold = PERIOD / 2; // Calculate threshold for toggling the clock
    counter = 0; // Initialize counter
    clk = 0; // Initialize generated clock signal to 0
end

always #1 begin
    counter <= counter + 1; // Increment counter at each time step
    
    if (counter >= threshold) begin
        counter <= 0; // Reset counter when it reaches the threshold
        clk <= ~clk; // Toggle the generated clock signal
    end
end

endmodule