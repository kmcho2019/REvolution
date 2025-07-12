module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);
    localparam integer half_period = PERIOD / 2;

    initial clk = 1'b0;

    always begin
        #(half_period);
        clk = ~clk;
    end
endmodule