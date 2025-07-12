module clkgenerator #(
    parameter PERIOD = 10       // Clock period in time units
)(
    output reg clk             // Generated clock output
);

    // Calculate half period
    localparam HALF_PERIOD = PERIOD / 2;

    // Initialize clock
    initial begin
        clk = 1'b0;
    end

    // Clock generation
    always begin
        #HALF_PERIOD clk = ~clk;
    end

endmodule