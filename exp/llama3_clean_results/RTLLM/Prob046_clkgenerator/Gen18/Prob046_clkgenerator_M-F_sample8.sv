module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

localparam HALF_PERIOD = PERIOD / 2; // Calculate half period at compile time

reg [7:0] counter; // Counter size can be adjusted based on PERIOD

initial begin
    clk = 0;
    counter = 0;
end

always #1 begin
    counter = counter + 1;
    if (counter == HALF_PERIOD) begin
        clk = ~clk;
        counter = 0; // Reset counter for the next cycle
    end
end

endmodule