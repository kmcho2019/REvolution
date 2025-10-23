module clkgenerator #(
    parameter PERIOD = 10
) (
    output reg clk
);

initial begin
    clk = 0;
end

always #((PERIOD / 2)) begin
    clk = ~clk;
end

endmodule