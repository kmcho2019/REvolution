module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

// Initialize clk to 0 at time 0
initial clk = 1'b0;

// Generate clock by toggling clk every half PERIOD
always begin
    #(PERIOD / 2);
    clk <= ~clk;
end

endmodule