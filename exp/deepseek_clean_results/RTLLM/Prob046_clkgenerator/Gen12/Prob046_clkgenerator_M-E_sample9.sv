`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output reg clk = 0,    // Generated clock output
    input wire enable,     // Clock enable signal
    input wire reset_n     // Active-low reset
);

    reg [31:0] counter = 0;
    wire half_period = (PERIOD/2);
    wire period_end = (counter >= PERIOD-1);
    wire half_period_end = (counter >= half_period-1);

    always @(posedge enable or negedge reset_n) begin
        if (!reset_n) begin
            clk <= 0;
            counter <= 0;
        end
    end

    always begin
        #1;  // Progress simulation time
        if (!reset_n) begin
            counter <= 0;
            clk <= 0;
        end
        else if (enable) begin
            counter <= counter + 1;
            
            if (period_end) begin
                counter <= 0;
                clk <= ~clk;
            end
            else if (half_period_end && !period_end) begin
                clk <= ~clk;
            end
        end
        else begin
            counter <= 0;
            clk <= 0;
        end
    end

endmodule