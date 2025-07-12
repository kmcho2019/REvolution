`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output reg clk,        // Generated clock output
    input wire enable      // Clock enable signal
);

    // Calculate half period for toggle timing
    localparam HALF_PERIOD = PERIOD / 2;

    // Clock generation
    initial clk = 1'b0;
    
    always begin
        if (enable) begin
            #HALF_PERIOD clk <= ~clk;
        end else begin
            clk <= 1'b0;
            @(posedge enable); // Wait until enabled
        end
    end

endmodule