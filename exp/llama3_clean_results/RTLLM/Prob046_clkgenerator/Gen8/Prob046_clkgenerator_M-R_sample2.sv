module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;

always @(counter) begin
    if (counter == (PERIOD / 2)) begin
        counter <= 0;
        clk <= ~clk;
    end else begin
        counter <= counter + 1;
    end
end

always #1 counter = counter + 1;

initial begin
    clk = 0; // Initialize the clock signal
    counter = 0;
end

endmodule