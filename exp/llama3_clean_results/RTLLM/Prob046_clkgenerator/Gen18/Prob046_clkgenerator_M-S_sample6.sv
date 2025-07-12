module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;

initial begin
    clk = 0;
end

always #1 begin
    counter = counter + 1;
    if (counter == (PERIOD / 2)) begin
        clk = ~clk; // toggle the clock signal
        counter = 0; // reset the counter
    end
end

endmodule