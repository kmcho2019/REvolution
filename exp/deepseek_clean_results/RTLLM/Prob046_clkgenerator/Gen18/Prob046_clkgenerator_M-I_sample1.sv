module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk = 0
);

    initial begin
        clk = 0;
        forever begin
            #(PERIOD/2) clk = ~clk;
        end
    end

endmodule