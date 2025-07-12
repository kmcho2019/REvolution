module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk = 1'b0
);

reg [31:0] counter = 0;

always @(counter) begin
    if (counter == (PERIOD / 2)) begin
        clk = ~clk; // toggle the clock signal
        counter = 0;
    end else begin
        counter = counter + 1;
    end
end

always @(*) begin
    #1;
    counter = counter;
end

endmodule