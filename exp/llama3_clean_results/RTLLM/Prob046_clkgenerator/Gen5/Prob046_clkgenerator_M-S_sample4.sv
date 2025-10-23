module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

always #((PERIOD / 2)) begin
    clk = ~clk;
end

initial begin
    clk = 0;
end

endmodule