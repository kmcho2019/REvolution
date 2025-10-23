module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk = 0
);

reg [31:0] counter = 0;
localparam HALF_PERIOD = PERIOD / 2;

always @(posedge counter) begin
    if (counter == HALF_PERIOD) begin
        clk <= ~clk;
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

always #1 counter <= counter + 1;

endmodule