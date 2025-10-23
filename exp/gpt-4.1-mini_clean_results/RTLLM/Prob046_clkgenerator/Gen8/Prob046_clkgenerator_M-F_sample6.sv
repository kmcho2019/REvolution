module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

// Initialize clk to 0 at time 0
initial begin
    clk = 1'b0;
end

// Toggle clk every half period
always begin
    #(PERIOD / 2) clk = ~clk;
end

endmodule