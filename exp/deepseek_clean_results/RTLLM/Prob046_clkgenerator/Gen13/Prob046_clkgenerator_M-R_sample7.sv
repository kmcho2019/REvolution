module clkgenerator #(
    parameter PERIOD = 10      // Clock period in time units
)(
    output reg clk            // Generated clock output
);

    // Calculate half period for precise timing
    localparam HALF_PERIOD = PERIOD / 2;
    
    // Initialize clock to 0
    initial clk = 1'b0;
    
    // Clock generation loop
    initial begin
        forever begin
            #HALF_PERIOD clk = ~clk;  // Toggle every half period
        end
    end

endmodule