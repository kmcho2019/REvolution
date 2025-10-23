module clkgenerator #(
    parameter PERIOD = 10 // Period of the generated clock
)(
    output reg clk
);

reg [31:0] counter = 0; // Counter to track the number of system clock cycles
reg old_clk = 1'b0; // Previous state of the output clock

always @(*) begin
    counter <= counter + 1; // Increment the counter at every clock cycle
    
    // Toggle the output clock when the counter reaches half of the period
    if (counter == (PERIOD / 2)) begin
        clk = ~old_clk; // Toggle the clock
        old_clk = ~old_clk; // Update the previous clock state
        counter = 0; // Reset the counter
    end else begin
        clk = old_clk; // Maintain the current clock state
    end
end

endmodule