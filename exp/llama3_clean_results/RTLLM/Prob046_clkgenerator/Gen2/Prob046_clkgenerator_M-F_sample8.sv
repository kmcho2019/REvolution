module clkgenerator #(
    parameter PERIOD = 10
)
(
    output reg clk
);

always
begin
    clk = 1'b0; // Initialize clock to 0
    # (PERIOD / 2); // Wait for half period
    clk = 1'b1; // Set clock to 1
    # (PERIOD / 2); // Wait for another half period
end

endmodule