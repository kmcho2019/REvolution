module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;
reg [31:0] half_period;

initial begin
    half_period = PERIOD / 2;
    clk = 0; // initialize the clock signal to 0
    counter = 0;
end

always begin
    #1; // delay for 1 time unit
    if (counter == half_period) begin
        clk = ~clk; // toggle the clock signal
        counter = 0; // reset the counter
    end else begin
        counter = counter + 1; // increment the counter
    end
end

endmodule