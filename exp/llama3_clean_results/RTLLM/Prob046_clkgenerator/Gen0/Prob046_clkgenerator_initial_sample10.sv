module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

initial begin
    clk = 0;
    forever begin
        #((PERIOD / 2)); // Delay for half of the period
        clk = ~clk; // Toggle the clock
    end
end

endmodule