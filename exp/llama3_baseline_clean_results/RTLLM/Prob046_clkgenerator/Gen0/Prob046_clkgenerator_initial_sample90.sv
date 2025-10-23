module clkgenerator(
    output reg clk
);

parameter PERIOD = 10;

initial clk = 0;
always
begin
    #(PERIOD/2) clk = ~clk;
end

endmodule