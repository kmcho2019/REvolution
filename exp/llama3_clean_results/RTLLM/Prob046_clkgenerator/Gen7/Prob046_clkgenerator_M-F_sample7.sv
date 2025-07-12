module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;

always begin
    #((PERIOD / 2)); // Delay for half of the period
    clk = ~clk; // Toggle the clock signal
end

initial begin
    clk = 0; // Initialize the clock signal
end

endmodule