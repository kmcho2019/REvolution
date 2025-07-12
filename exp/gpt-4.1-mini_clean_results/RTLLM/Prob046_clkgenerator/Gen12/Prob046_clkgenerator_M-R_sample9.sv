`timescale 1ns / 1ps

module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

localparam HALF_PERIOD = PERIOD / 2;

integer counter;

initial begin
    clk = 1'b0;
    counter = 0;
    forever begin
        #1; // advance simulation time by 1 time unit
        counter = counter + 1;
        if (counter >= HALF_PERIOD) begin
            clk = ~clk;
            counter = 0;
        end
    end
end

endmodule