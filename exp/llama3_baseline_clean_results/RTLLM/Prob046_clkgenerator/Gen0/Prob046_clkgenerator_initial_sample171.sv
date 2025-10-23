module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

initial begin
    clk = 0;
    forever begin
        #((PERIOD / 2)); // wait for half of the period
        clk = ~clk; // toggle the clock signal
    end
end

endmodule