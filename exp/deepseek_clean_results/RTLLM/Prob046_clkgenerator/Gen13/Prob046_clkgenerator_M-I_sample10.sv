module clkgenerator #(
    parameter PERIOD = 10      // Clock period in time units
)(
    output reg clk = 0         // Generated clock output (initialized to 0)
);

    // Clock generation using forever loop (simulation only)
    initial begin
        forever begin
            #(PERIOD/2) clk = ~clk;  // Toggle every half period
        end
    end

endmodule