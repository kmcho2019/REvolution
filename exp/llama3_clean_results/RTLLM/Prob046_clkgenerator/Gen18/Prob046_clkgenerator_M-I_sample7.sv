module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter;

always #((PERIOD / 2)) begin
    // Toggle the clock state
    clk = ~clk;
end

initial begin
    // Initialize the clock state
    clk = 1'b0;
end

endmodule