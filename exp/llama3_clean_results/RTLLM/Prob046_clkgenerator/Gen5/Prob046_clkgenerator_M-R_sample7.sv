module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

always begin
    #(PERIOD / 2) clk = 1; // Set the clock signal high
    #(PERIOD / 2) clk = 0; // Set the clock signal low
end

initial begin
    clk = 0; // Initialize the clock signal
end

endmodule