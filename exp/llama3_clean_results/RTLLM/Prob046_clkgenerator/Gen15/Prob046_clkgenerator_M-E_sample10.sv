module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;

always begin
    #((PERIOD / 2)); // wait for half of the period
    clk = ~clk; // toggle the clock signal
end

initial begin
    clk = 0; // initialize the clock signal to 0
end

endmodule