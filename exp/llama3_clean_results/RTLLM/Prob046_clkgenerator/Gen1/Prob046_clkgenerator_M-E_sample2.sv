module clkgenerator #(
    parameter PERIOD = 10
) (
    output reg clk
);

reg [31:0] counter;
reg clk_reg;

always @(posedge counter) begin
    if (counter == (PERIOD / 2)) begin
        clk_reg = ~clk_reg;
    end
    if (counter == PERIOD) begin
        counter = 0;
    end
end

assign clk = clk_reg;

initial begin
    counter = 0;
    clk_reg = 0;
end

always #1 begin
    counter = counter + 1;
end

endmodule