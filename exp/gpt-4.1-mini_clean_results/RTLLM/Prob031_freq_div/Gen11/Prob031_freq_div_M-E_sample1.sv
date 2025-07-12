/**
 * freq_div.v
 *
 * Frequency Divider Module using a single shared counter.
 *
 * Inputs:
 *   CLK_in - 100 MHz input clock
 *   RST    - synchronous active-high reset
 *
 * Outputs:
 *   CLK_50 - 50 MHz clock output (CLK_in / 2)
 *   CLK_10 - 10 MHz clock output (CLK_in / 10)
 *   CLK_1  -  1 MHz clock output (CLK_in / 100)
 *
 * The module uses a single 7-bit counter counting 0 to 99.
 * The output clocks toggle based on counter values corresponding to their half-periods.
 */

module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] counter;  // 0 to 99

    always @(posedge CLK_in) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            if (counter == 7'd99) 
                counter <= 7'd0;
            else
                counter <= counter + 7'd1;

            // CLK_50 toggles every 1 input clock cycle (half period = 1 cycle)
            // We toggle CLK_50 at every odd counter value (counter[0] == 1)
            if (counter[0] == 1'b1)
                CLK_50 <= ~CLK_50;

            // CLK_10 toggles every 5 input clock cycles (half period = 5 cycles)
            // Toggle CLK_10 when counter reaches 4,14,24,... i.e. (counter % 10 == 4)
            if ((counter % 10) == 7'd4)
                CLK_10 <= ~CLK_10;

            // CLK_1 toggles every 50 input clock cycles (half period = 50 cycles)
            // Toggle CLK_1 at counter 49
            if (counter == 7'd49)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule