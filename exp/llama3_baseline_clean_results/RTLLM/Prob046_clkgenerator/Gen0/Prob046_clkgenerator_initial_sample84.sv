module clkgenerator(
    output reg clk
);

parameter PERIOD = 10;

initial begin
    clk = 0;
    forever begin
        #((PERIOD / 2)); // Toggle clock every half period
        clk = ~clk; // Invert the clock state
    end
end

endmodule