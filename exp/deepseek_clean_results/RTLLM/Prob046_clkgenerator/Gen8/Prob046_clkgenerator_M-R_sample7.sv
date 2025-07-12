module clkgenerator #(
    parameter PERIOD = 10       // Clock period in base clock cycles (must be even)
)(
    output reg clk = 0          // Generated clock output (initialized to 0)
);

    // Validate parameter (PERIOD must be even for 50% duty cycle)
    initial begin
        if (PERIOD % 2 != 0) begin
            $error("PERIOD must be even for 50%% duty cycle");
            $finish;
        end
    end

    // Calculate half period
    localparam HALF_PERIOD = PERIOD / 2;
    
    // Counter for clock generation
    reg [$clog2(HALF_PERIOD)-1:0] counter = HALF_PERIOD - 1;

    // Clock generation process
    always begin
        #HALF_PERIOD;           // Wait for half period
        clk = ~clk;             // Toggle clock
    end

endmodule