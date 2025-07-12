module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;

always #1 begin
    counter <= counter + 1;
    if (counter == (PERIOD / 2)) begin
        counter <= 0;
        clk <= ~clk; // Toggle the clock signal
    end
end

initial begin
    clk = 0;
end

endmodule