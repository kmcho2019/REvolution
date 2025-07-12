module clkgenerator #(
    parameter PERIOD = 10
)
(
    output reg clk
);

initial clk = 1'b0; // Initialize clock to 0

always #((PERIOD / 2)) clk = ~clk; // Toggle clock every half period

endmodule