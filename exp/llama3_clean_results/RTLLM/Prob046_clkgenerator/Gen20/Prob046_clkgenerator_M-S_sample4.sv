module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;
reg clk_int = 1'b0;

always #((PERIOD / 2)) clk_int = ~clk_int;

always @(posedge clk_int) begin
    if (counter == (PERIOD / 2)) begin
        counter = 0;
    end else begin
        counter = counter + 1;
    end
end

assign clk = clk_int;

endmodule