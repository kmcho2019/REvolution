module clkgenerator(
    output reg clk
);

parameter PERIOD = 10;

reg [31:0] cnt;

always #((PERIOD / 2)) begin
    clk <= ~clk;
end

initial begin
    clk = 0;
end

endmodule