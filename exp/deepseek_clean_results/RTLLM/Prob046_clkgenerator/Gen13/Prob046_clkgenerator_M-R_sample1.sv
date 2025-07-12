`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output wire clk,       // Generated clock output
    input wire enable      // Clock enable signal
);

    // Calculate half period for toggle timing
    localparam HALF_PERIOD = PERIOD / 2;
    
    reg [31:0] counter = 0;
    reg clk_reg = 0;
    
    // Counter for timing control
    always begin
        #1;  // Progress simulation time
        counter <= (counter >= PERIOD-1) ? 0 : counter + 1;
    end
    
    // Toggle clock on half-period boundaries
    always @(counter) begin
        if (enable && (counter % HALF_PERIOD == 0)) begin
            clk_reg <= ~clk_reg;
        end
    end
    
    // Gate the clock with enable signal
    assign clk = enable ? clk_reg : 1'b0;

endmodule