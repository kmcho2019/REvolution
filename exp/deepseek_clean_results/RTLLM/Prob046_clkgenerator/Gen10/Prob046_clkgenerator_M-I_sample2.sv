module clkgenerator #(
    parameter PERIOD = 10,       // Clock period in reference clock cycles
    parameter REF_CLK_PERIOD = 1  // Reference clock period (default 1 time unit)
)(
    input ref_clk,               // Reference clock input
    input reset_n,               // Active-low reset
    input enable,                // Clock enable control
    output reg clk = 0           // Generated clock output
);

    // Calculate half-period in reference clock cycles
    localparam HALF_PERIOD = PERIOD / (2 * REF_CLK_PERIOD);
    
    // Counter to track reference clock cycles
    reg [$clog2(HALF_PERIOD+1)-1:0] counter = 0;

    always @(posedge ref_clk or negedge reset_n) begin
        if (!reset_n) begin
            // Reset state
            clk <= 0;
            counter <= 0;
        end
        else if (enable) begin
            // Increment counter
            counter <= counter + 1;
            
            // Toggle clock when half-period reached
            if (counter >= HALF_PERIOD-1) begin
                clk <= ~clk;
                counter <= 0;
            end
        end
    end

endmodule