module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter;
reg [31:0] half_period;

initial begin
    half_period = PERIOD / 2;
    clk = 0;
    counter = 0;
end

always #1 begin
    counter <= counter + 1;
    if (counter == half_period) begin
        clk <= ~clk;
        counter <= 0;
    end
end

endmodule