module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [3:0] counter; // Use a counter size that can accommodate the maximum possible period

initial begin
    clk = 0;
    counter = 0;
end

always #1 clk = ~clk; // Use a separate clock signal to drive the always block

always @(posedge clk) begin
    if (counter >= (PERIOD / 2 - 1)) begin // Toggle clock when counter reaches half of the period
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

endmodule