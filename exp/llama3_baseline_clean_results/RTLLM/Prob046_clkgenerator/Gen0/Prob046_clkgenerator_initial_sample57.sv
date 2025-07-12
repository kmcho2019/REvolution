module clkgenerator #(
    parameter PERIOD = 10
) (
    output reg clk
);

initial begin
    clk = 0;
end

always begin
    #((PERIOD / 2)); // Toggle clock every half period
    clk = ~clk; // Invert clock state
end

endmodule