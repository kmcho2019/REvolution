`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output reg clk         // Generated clock output
);

    reg [31:0] counter;
    wire half_period = PERIOD / 2;

    // Initialize clock and counter
    initial begin
        clk = 0;
        counter = 0;
    end

    // Free-running counter and clock generation
    always begin
        #1;  // Smallest time increment
        counter = counter + 1;
        
        // Toggle clock at half period intervals
        if (counter % half_period == 0) begin
            clk = ~clk;
        end
    end

endmodule