module clkgenerator #(
    parameter PERIOD = 10       // Clock period in time units
)(
    output reg clk             // Generated clock output
);

    localparam HALF_PERIOD = PERIOD / 2;

    initial begin
        clk = 1'b0;            // Initialize clock to 0
        forever #HALF_PERIOD clk = ~clk;  // Toggle every half period
    end

endmodule