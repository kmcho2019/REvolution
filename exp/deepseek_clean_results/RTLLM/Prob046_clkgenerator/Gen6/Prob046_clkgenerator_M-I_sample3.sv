`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10,  // Clock period in ns (must be even)
    parameter CLK_IN_PERIOD = 2  // Input clock period in ns
) (
    input wire clk_in,      // Input clock (higher frequency)
    input wire reset_n,     // Active-low reset
    output reg clk_out      // Generated clock output
);

    // Calculate counter limit (half of desired period in input clock cycles)
    localparam HALF_PERIOD_CYCLES = (PERIOD/2)/CLK_IN_PERIOD;
    
    reg [31:0] counter;
    
    // Parameter validation using generate
    generate
        if (PERIOD <= 0) begin
            initial $fatal("PERIOD must be positive");
        end
        if (PERIOD % 2 != 0) begin
            initial $warning("PERIOD should be even for 50%% duty cycle");
        end
        if (PERIOD < CLK_IN_PERIOD*2) begin
            initial $fatal("PERIOD must be at least twice CLK_IN_PERIOD");
        end
    endgenerate

    // Clock generation logic
    always @(posedge clk_in or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == HALF_PERIOD_CYCLES - 1) begin
                clk_out <= ~clk_out;
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule