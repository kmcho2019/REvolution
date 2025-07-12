`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10 // Clock period in ns (must be positive and even)
) (
    output reg clk = 0,  // Initialized to 0
    input enable = 1,    // Optional clock enable (default on)
    input stop = 0       // Optional stop control (default off)
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
    if (!stop) begin
        clk = enable ? ~clk : 1'b0;
    end
    else begin
        clk = 1'b0;
        $finish; // Optional: stop simulation when stop is asserted
    end
end

endmodule