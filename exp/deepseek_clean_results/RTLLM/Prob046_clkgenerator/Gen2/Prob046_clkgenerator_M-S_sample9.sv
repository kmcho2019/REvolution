module clkgenerator #(parameter PERIOD = 10) (
    output reg clk = 0
);

    initial begin
        forever begin
            #(PERIOD/2) clk = ~clk;
        end
    end

endmodule