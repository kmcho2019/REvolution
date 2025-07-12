module clkgenerator #(
    parameter PERIOD = 10       // Clock period in time units
)(
    output reg clk = 0          // Generated clock output with initial value
);

    localparam HALF_PERIOD = PERIOD / 2;

    // Clock generation process
    always begin
        #HALF_PERIOD clk = ~clk;  // Toggle clock every half period
    end

endmodule