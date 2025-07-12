module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

localparam HALF_PERIOD = PERIOD / 2;

initial begin
    clk = 0; // Initial state of the clock signal
end

always begin
    #HALF_PERIOD clk = ~clk; // Toggle clock signal every half period
end

endmodule