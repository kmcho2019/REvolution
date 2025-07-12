module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

initial begin
    clk = 0;
end

always begin
    #((PERIOD / 2)); // wait for half of the period
    clk = ~clk; // toggle the clock
end

endmodule