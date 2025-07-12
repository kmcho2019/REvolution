module clkgenerator #(
    parameter PERIOD = 10  // Clock period in time units
)(
    output reg clk         // Clock output
);

    localparam HALF_PERIOD = PERIOD/2;

    initial clk = 1'b0;

    always #HALF_PERIOD clk = ~clk;

endmodule