module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;

always @(counter) begin
    if (counter == (PERIOD / 2)) begin
        clk = ~clk; // toggle the clock signal
        counter = 0; // reset the counter
    end else begin
        counter = counter + 1; // increment the counter
    end
end

initial begin
    clk = 0; // initialize the clock signal to 0
end

endmodule