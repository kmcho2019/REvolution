module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

// Initialize clk and generate clock by toggling every half period
initial begin
    clk = 1'b0;
    forever #(PERIOD/2) clk = ~clk;
end

endmodule