module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;
reg clk_i = 0;

always #1 clk_i = ~clk_i;

always @(posedge clk_i) begin
    counter = counter + 1;
    if (counter == (PERIOD / 2)) begin
        clk = ~clk;
        counter = 0;
    end
end

endmodule