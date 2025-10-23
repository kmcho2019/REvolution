module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

always begin
    clk = 1'b0; // Initialize clock low
    #((PERIOD / 2)); // Delay for half the period
    clk = 1'b1; // Set clock high
    #((PERIOD / 2)); // Delay for the other half of the period
end

endmodule