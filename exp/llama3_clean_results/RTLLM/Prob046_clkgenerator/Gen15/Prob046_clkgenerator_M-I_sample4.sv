module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

localparam COUNTER_WIDTH = $clog2(PERIOD);
reg [COUNTER_WIDTH-1:0] counter = 0;

always #((PERIOD / 2)) clk = ~clk;

always @(posedge clk) begin
    counter = counter + 1;
    if (counter == (PERIOD / 2 - 1)) begin
        counter = 0;
    end
end

endmodule