module clkgenerator(output reg clk=0);
    always #5 clk = ~clk;
endmodule