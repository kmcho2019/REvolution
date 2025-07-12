module clkgenerator(
    output reg clk
);

parameter PERIOD = 10;

initial begin
    clk = 0; // Initialize the clock signal to 0
    forever begin
        #((PERIOD / 2)) clk = ~clk; // Toggle the clock signal every half of the period
    end
end

endmodule