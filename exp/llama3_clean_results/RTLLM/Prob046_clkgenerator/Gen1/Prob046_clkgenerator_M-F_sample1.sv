module clkgenerator #(
    parameter PERIOD = 10
)
(
    output reg clk
);

initial
begin
    clk = 1'b0; // Initialize clock signal to 0
    forever
    begin
        # (PERIOD / 2) clk = ~clk; // Toggle clock every half period
    end
end

endmodule