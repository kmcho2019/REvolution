module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk = 0
);

reg [$clog2(PERIOD / 2 + 1) - 1:0] counter = 0;

always #1 begin
    counter <= counter + 1;
    if (counter == (PERIOD / 2)) begin
        clk <= ~clk;
        counter <= 0;
    end
end

endmodule