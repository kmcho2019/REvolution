`timescale 1ns / 1ps

module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

reg [31:0] count;

initial begin
    clk = 0;
    count = 0;
end

always begin
    #1; // advance simulation time by 1 time unit
    count = count + 1;
    if (count == (PERIOD/2)) begin
        clk = ~clk;
        count = 0;
    end
end

endmodule