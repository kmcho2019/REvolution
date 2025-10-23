module clkgenerator #(
    parameter PERIOD = 10  // Number of input clock cycles for full output clock period
)(
    input  wire clk_in,
    output reg  clk = 0
);

localparam HALF_PERIOD = PERIOD / 2;

reg [$clog2(PERIOD)-1:0] count = 0;

always @(posedge clk_in) begin
    if (count == HALF_PERIOD - 1) begin
        clk <= ~clk;
        count <= 0;
    end else begin
        count <= count + 1;
    end
end

endmodule