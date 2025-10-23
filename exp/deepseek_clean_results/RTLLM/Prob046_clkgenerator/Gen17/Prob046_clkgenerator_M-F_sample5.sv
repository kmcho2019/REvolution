module clkgenerator #(
    parameter PERIOD = 10  // Clock period in time units
)(
    output reg clk         // Clock output
);

    initial begin
        clk = 0;           // Initialize clock to 0
        forever begin
            #(PERIOD/2);   // Wait half period
            clk = ~clk;    // Toggle clock
        end
    end

endmodule