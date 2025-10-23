module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);
    // Calculate half period as integer for integral delay
    localparam integer half_period = PERIOD / 2;

    initial begin
        clk = 1'b0;
        forever begin
            #(half_period) clk = ~clk;
        end
    end
endmodule