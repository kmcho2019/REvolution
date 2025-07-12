module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

initial begin
    clk = 0; // Initialize the clock signal
end

always begin
    #((PERIOD / 2)) clk = ~clk; // Toggle the clock signal
end

endmodule