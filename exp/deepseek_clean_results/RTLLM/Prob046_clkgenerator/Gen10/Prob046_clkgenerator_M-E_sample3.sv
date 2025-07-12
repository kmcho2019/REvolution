`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output reg clk          // Generated clock output
);

    reg [31:0] counter = 0;  // Free-running counter
    reg base_clock = 0;      // Internal base clock (1ns period)

    // Generate base clock (1ns period)
    always begin
        #0.5 base_clock = ~base_clock;
    end

    // Counter and clock generation logic
    always @(posedge base_clock) begin
        if (counter >= PERIOD-1) begin
            counter <= 0;
            clk <= ~clk;
        end
        else if (counter == (PERIOD/2)-1) begin
            counter <= counter + 1;
            clk <= ~clk;
        end
        else begin
            counter <= counter + 1;
        end
    end

    // Initialization
    initial begin
        clk = 0;
        counter = 0;
    end

endmodule