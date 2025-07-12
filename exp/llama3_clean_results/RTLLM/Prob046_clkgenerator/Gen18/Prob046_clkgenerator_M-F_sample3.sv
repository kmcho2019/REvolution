module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

endmodule