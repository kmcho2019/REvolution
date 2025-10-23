module clkgenerator (
    output reg clk
);

parameter PERIOD = 10;

initial begin
    clk = 0;  // Set initial state of the clock signal to 0
    forever begin
        #((PERIOD / 2));  // Wait for half of the specified period
        clk = ~clk;  // Toggle the clock signal
    end
end

endmodule