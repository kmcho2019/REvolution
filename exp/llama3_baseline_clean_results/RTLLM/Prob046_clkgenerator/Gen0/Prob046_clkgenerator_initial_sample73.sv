module clkgenerator(
    output reg clk
);

parameter PERIOD = 10;

initial begin
    clk = 0;
    forever begin
        #5 clk = ~clk;
    end
end

endmodule