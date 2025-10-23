`timescale 1ns / 1ps

module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

integer counter;

initial begin
    clk = 0;
    counter = 0;
end

always begin
    #1;                  // Wait 1 time unit
    counter = counter + 1;
    if (counter >= (PERIOD/2)) begin
        clk = ~clk;
        counter = 0;
    end
end

endmodule