module clkgenerator
#(parameter PERIOD = 10)
(
    output reg clk
);

always
#(PERIOD / 2) clk <= ~clk;

initial
begin
    clk = 0;
end

endmodule