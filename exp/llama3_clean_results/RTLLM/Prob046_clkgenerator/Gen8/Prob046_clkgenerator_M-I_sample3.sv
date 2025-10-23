module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk = 1'b0
);

localparam HALF_PERIOD = PERIOD / 2;

reg [$clog2(HALF_PERIOD + 1) - 1:0] counter = 0;

always #1 begin
    counter <= counter + 1;
    if (counter == HALF_PERIOD) begin
        clk <= ~clk;
        counter <= 0;
    end
end

endmodule