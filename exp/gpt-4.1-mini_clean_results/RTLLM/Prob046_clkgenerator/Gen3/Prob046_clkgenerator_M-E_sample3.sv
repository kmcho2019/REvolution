`timescale 1ns / 1ps

module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

integer counter;

initial begin
    clk = 0;
    counter = 0;
end

always @(posedge clk or negedge clk) begin
    // Not used, kept empty to avoid latches or infer clock domain
end

always begin
    #1; // Tick every 1 time unit
    counter = counter + 1;
    if (counter >= (PERIOD / 2)) begin
        clk = ~clk;
        counter = 0;
    end
end

endmodule