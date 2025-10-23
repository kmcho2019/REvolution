module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk = 0
);

reg [31:0] counter = 0;

always begin
    #((PERIOD / 2));
    clk = ~clk; // toggle the clock signal
end

endmodule