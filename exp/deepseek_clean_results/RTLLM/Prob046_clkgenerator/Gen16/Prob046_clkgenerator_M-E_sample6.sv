module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

    initial begin
        clk = 0;  // Initialize clock to 0
        forever #(PERIOD/2) clk = ~clk;  // Toggle every half period
    end

endmodule