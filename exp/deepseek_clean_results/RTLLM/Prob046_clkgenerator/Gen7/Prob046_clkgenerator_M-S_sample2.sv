module clkgenerator #(
    parameter PERIOD = 10
) (
    output reg clk = 0
);

    // Calculate half period for 50% duty cycle
    localparam HALF_PERIOD = PERIOD / 2;

    // Continuous clock toggling
    always begin
        #HALF_PERIOD clk = ~clk;
    end

endmodule