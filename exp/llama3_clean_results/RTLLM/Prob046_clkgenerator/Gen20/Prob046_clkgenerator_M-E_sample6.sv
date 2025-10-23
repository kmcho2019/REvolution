module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;

always #1 begin
    counter <= counter + 1;
    if (counter == (PERIOD / 2)) begin
        clk <= ~clk;
        counter <= 0;
    end
end

initial begin
    // Initialize the clock state
    clk = 1'b0;
end

endmodule