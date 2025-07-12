module clkgenerator #(
    parameter PERIOD = 10       // Clock period in time units
)(
    output reg clk             // Generated clock output
);

    initial begin
        clk = 1'b0;           // Initialize clock low
        forever begin
            #(PERIOD/2) clk = ~clk;  // Toggle every half period
        end
    end

endmodule