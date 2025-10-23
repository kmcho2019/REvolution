module clkgenerator #(
    parameter PERIOD = 10, // Desired period of the generated clock
    parameter REF_CLK_FREQ = 100 // Frequency of the reference clock
)(
    input clk_ref, // Reference clock
    output reg clk_out // Generated clock signal
);

reg [31:0] counter; // Counter to track the number of reference clock cycles
reg [31:0] threshold; // Threshold value based on the desired period and reference clock frequency

initial begin
    threshold = (PERIOD * REF_CLK_FREQ) / 2; // Calculate threshold for toggling the clock
    counter = 0; // Initialize counter
    clk_out = 0; // Initialize generated clock signal to 0
end

always @(posedge clk_ref) begin
    counter <= counter + 1; // Increment counter at each rising edge of the reference clock
    
    if (counter >= threshold) begin
        counter <= 0; // Reset counter when it reaches the threshold
        clk_out <= ~clk_out; // Toggle the generated clock signal
    end
end

endmodule