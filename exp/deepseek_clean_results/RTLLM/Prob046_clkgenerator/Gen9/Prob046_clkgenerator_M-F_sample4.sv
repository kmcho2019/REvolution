module clkgenerator #(
    parameter PERIOD = 10  // Clock period in time units
)(
    output reg clk = 0
);

    // Calculate half-period for clock toggling
    localparam HALF_PERIOD = PERIOD / 2;
    
    // Counter to track time since last toggle
    integer counter = 0;

    always begin
        // Wait for one time unit
        #1;
        
        // Increment counter and check if half-period reached
        counter = counter + 1;
        if (counter >= HALF_PERIOD) begin
            clk = ~clk;         // Toggle clock
            counter = 0;        // Reset counter
        end
    end

    // Initialization (optional, as reg is initialized to 0)
    initial begin
        clk = 0;
    end

endmodule