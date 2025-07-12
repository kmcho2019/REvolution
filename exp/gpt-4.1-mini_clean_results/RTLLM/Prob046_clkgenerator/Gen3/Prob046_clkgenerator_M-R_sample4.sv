module clkgenerator #(parameter real PERIOD = 10.0) (
    output reg clk
);

initial clk = 0;

always begin
    #(PERIOD/2) clk = ~clk;
end

endmodule