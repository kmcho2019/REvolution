module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk = 0
);

    always begin
        #(PERIOD/2) clk = ~clk;
    end

endmodule