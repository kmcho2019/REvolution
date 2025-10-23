`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10 // Clock period in ns (must be positive and even)
) (
    output reg clk = 0,          // Generated clock signal
    input wire enable = 1'b1,    // Clock enable (active high, 1-bit)
    input wire stop = 1'b0,      // Clock stop (active high, 1-bit)
    input wire reset = 1'b0      // Synchronous reset (optional)
);

// Validate parameters
initial begin
    if (PERIOD <= 0) begin
        $error("PERIOD must be positive");
        $finish;
    end
    if (PERIOD % 2 != 0) begin
        $error("PERIOD must be even");
        $finish;
    end
end

always begin
    #(PERIOD/2);
    if (reset) begin
        clk <= 1'b0;
    end
    else if (!stop) begin
        clk <= enable ? ~clk : 1'b0;
    end
    // When stop=1, clock maintains its last state
end

endmodule