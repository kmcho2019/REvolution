`timescale 1ns / 1ps

module clkgenerator #(parameter PERIOD = 10)(
    output reg clk
);

localparam HALF_PERIOD = PERIOD / 2;

initial begin
    clk = 0; // Initialize clock to 0
    forever begin
        #(HALF_PERIOD) clk = ~clk; // Toggle clock every half period
    end
end

endmodule