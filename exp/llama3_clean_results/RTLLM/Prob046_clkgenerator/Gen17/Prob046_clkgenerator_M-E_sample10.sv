module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] ring_oscillator = 0;
reg [31:0] counter = 0;

initial begin
    clk = 0;
    ring_oscillator = 1;
end

always @(posedge ring_oscillator) begin
    counter = counter + 1;
    if (counter == (PERIOD / 2)) begin
        clk = ~clk; // toggle the clock signal
        counter = 0; // reset the counter
    end
end

always #1 ring_oscillator = ~ring_oscillator; // simulate the ring oscillator

endmodule