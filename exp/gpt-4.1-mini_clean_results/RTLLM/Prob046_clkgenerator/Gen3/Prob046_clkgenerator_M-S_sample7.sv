`timescale 1ns/1ps

module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

always begin
    clk = 0;
    #(PERIOD/2);
    clk = 1;
    #(PERIOD/2);
end

endmodule