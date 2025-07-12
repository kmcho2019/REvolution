module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk = 1'b0
);
    localparam integer half_period = PERIOD / 2;

    initial begin
        forever begin
            #(half_period);
            clk <= ~clk;
        end
    end
endmodule