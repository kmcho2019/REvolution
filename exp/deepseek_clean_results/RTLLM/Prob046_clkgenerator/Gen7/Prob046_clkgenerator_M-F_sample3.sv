module clkgenerator #(
    parameter PERIOD = 10,
    parameter INPUT_CLK_PERIOD = 1  // Period of input clock in same time units
) (
    input wire clk_in,      // Input clock from hardware
    input wire reset,        // Active-high reset
    output reg clk_out       // Generated clock output
);

    // Calculate number of input clock cycles needed for half period
    localparam HALF_PERIOD_CYCLES = (PERIOD/2)/INPUT_CLK_PERIOD;
    
    reg [31:0] counter;
    
    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;
        end
        else begin
            if (counter == HALF_PERIOD_CYCLES - 1) begin
                clk_out <= ~clk_out;
                counter <= 0;
            end
            else begin
                counter <= counter + 1;
            end
        end
    end

endmodule