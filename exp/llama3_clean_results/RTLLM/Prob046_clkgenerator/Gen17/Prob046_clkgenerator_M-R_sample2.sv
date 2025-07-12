module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [7:0] counter; // Assuming 8 bits are enough to hold the period
reg [7:0] half_period;

initial begin
    clk = 0;
    half_period = PERIOD / 2;
    counter = 0;
end

always #1 begin
    counter = counter + 1;
    if (counter == half_period) begin
        clk = ~clk;
        counter = 0; // Reset counter for the next cycle
    end
end

endmodule