module clkgenerator #(
    parameter PERIOD = 10
) (
    output reg clk
);

initial begin
    clk = 0;
    forever begin
        #((PERIOD / 2)); // Toggle clock every half of the specified period
        clk = ~clk; // Toggle the clock signal
    end
end

endmodule