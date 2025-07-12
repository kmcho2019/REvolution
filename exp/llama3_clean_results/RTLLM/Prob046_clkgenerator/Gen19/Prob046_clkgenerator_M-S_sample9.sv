module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

initial begin
    clk = 0; // initialize the clock signal to 0
end

always begin
    #5; // delay for half of the period
    clk = ~clk; // toggle the clock signal
end

endmodule