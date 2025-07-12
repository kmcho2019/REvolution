module clkgenerator(
    output reg clk
);

parameter PERIOD = 10;

initial begin
    clk = 0;
    forever begin
        #(PERIOD / 2) clk = ~clk;
        $display("Current clock state: %b", clk);
    end
end

endmodule