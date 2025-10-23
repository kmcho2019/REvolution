module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk  // Generated clock signal
);

reg [31:0] counter = 0;

always #((PERIOD / 2)) clk = ~clk;

initial begin
    clk = 0;
    forever #1;
end

endmodule