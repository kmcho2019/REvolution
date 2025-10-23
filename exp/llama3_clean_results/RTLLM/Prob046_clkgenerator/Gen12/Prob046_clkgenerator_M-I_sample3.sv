module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

always begin
    #((PERIOD / 2)); // Delay for half of the period
    clk = ~clk; // Toggle clock signal
end

endmodule