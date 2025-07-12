module clkgenerator(
    output reg clk
);

parameter PERIOD = 10;

initial begin
    clk = 0; // Initialize clock signal to 0
    forever begin
        #((PERIOD / 2)) clk = ~clk; // Toggle clock every half of the PERIOD
    end
end

endmodule