module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [$clog2(PERIOD)-1:0] counter = 0;
always @(posedge counter) begin
    counter <= counter + 1;
    if (counter == PERIOD) begin
        counter <= 0;
    end
end
assign clk = (counter < (PERIOD / 2)) ? 1'b0 : 1'b1;

endmodule