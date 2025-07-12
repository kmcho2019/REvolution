module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

integer half_period_count;

initial begin
    clk = 1'b0;
    half_period_count = PERIOD / 2;
    forever begin
        #(half_period_count);
        clk = ~clk;
    end
end

endmodule