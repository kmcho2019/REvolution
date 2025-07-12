`timescale 1ns / 1ps

module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

localparam integer HALF_PERIOD = PERIOD / 2;

reg [31:0] counter;

initial begin
    clk = 0;
    counter = 0;
    fork
        forever begin
            #1; // Increment counter every 1 time unit
            if (counter == HALF_PERIOD - 1) begin
                clk = ~clk;
                counter = 0;
            end else begin
                counter = counter + 1;
            end
        end
    join_none
end

endmodule