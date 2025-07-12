module clkgenerator (
    output reg clk
);

parameter PERIOD = 10;

initial begin
    clk = 0;
end

always begin
    #((PERIOD / 2)); // Delay for half of the period
    clk = ~clk; // Toggle the clock signal
end

endmodule