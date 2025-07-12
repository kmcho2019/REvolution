module clkgenerator #(
    parameter PERIOD = 10
) (
    output reg clk
);

    // Calculate half period for 50% duty cycle
    localparam HALF_PERIOD = PERIOD / 2;

    // Initialize clock
    initial begin
        clk = 0;
        forever begin
            #HALF_PERIOD clk = ~clk;
        end
    end

endmodule