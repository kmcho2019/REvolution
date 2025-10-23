module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0; // Counter to manage the clock signal
reg clk_reg = 1'b0; // Register for the clock signal

always #1 begin
    counter <= counter + 1; // Increment counter at every time step
    if (counter >= (PERIOD / 2)) begin
        counter <= 0; // Reset counter when threshold is reached
        clk_reg <= ~clk_reg; // Toggle clock signal
    end
end

assign clk = clk_reg; // Assign clock signal to output

endmodule