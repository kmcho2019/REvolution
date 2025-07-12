module clkgenerator #
(
    parameter PERIOD = 10
)
(
    output reg clk
);

initial
begin
    clk = 0; // Initialize clock signal to 0
end

always
begin
    #((PERIOD / 2)); // Wait for half of the period
    clk = ~clk; // Toggle the clock signal
end

endmodule